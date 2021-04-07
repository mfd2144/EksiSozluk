//
//  FirebaseService.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 1.04.2021.
//

import UIKit
import Firebase

protocol FireBaseCellDelegate {
    func decideToFavoriteImage(_ fill:Bool)
}

class FirebaseService:NSObject{
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    lazy var userCollection = db.collection("User")
    lazy var entryCollection = db.collection("Entry")
    var listener :ListenerRegistration?
    var authStatus :((Status)->())?
    var favoriteArray = [FavoriteStruct]()
    var cellDelegate:FireBaseCellDelegate?
    
    
    override init() {
        super.init()
        if user != nil {
            authStatus?(.login)
        }else{
            authStatus?(.logout)
        }
        
    }
    
    
    
    //MARK: -  User methods
    
    func createUser(userInfo:UserStruct){
        Auth.auth().createUser(withEmail: userInfo.email, password: userInfo.password) { authResult, error in
            if let error = error {
                print("Adding new user error\(error)")
            }else{
                let changeRequest = authResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = userInfo.nick
                changeRequest?.commitChanges(completion: { (error) in
                    if let _ = error {
                        print("User couldn't be created \(error!.localizedDescription)")
                    }
                    guard let currentUser = authResult?.user else {return}
                    self.saveNewUsersInfo(userInfo,currentUser)
                })
            }
        }
    }
    
    private func saveNewUsersInfo(_ userInfo: UserStruct,_ currentUser:User){
        userCollection.addDocument(data: [user_nick : userInfo.nick,
                                          create_date: userInfo.createDate,
                                          user_birthday: userInfo.birtday,
                                          user_gender:userInfo.gender,
                                          user_ID :currentUser.uid,
                                          
                                          
        ]){ error in
            guard let _ = error else {return}
            print("User information couldn't be added \(error!.localizedDescription)")
        }
    }
    
    func userSignIn(_ email:String,_ password:String){
        Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
            if let error = error {
                print(error)
            }else{
                self.authStatus?(.login)
                self.doAfterSingIn()
            }
        }
    }
    
    func doAfterSingIn(){
        print("open a new view control")
    }
    
    
    func logout(){
        do {
            try Auth.auth().signOut()
        }catch{
            print("logut error \(error.localizedDescription)")
            return
        }
        self.authStatus?(.logout)
    }
    
}



extension FirebaseService{
    //MARK: - Entity processes
    
    
    func addNewEntity(entry:EntryStruct){
        
        entryCollection.addDocument(data: [entry_text : entry.entryLabel,
                                           comments_number:entry.comments,
                                           user_ID:entry.userID,
                                           create_date:entry.date
        ]) { (error) in
            if let _ = error{
                print("entity could't be created  \(error!.localizedDescription)")
            }
        }
    }
    
    func fetchEntities(handler:@escaping([EntryStruct],Error?)->()){
        listener = entryCollection.order(by: create_date, descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                var entities = [EntryStruct]()
                if let error = error{
                    handler(entities,error)
                }else{
                    guard let querySnapshotDocs = querySnapshot?.documents else { handler(entities,nil)
                        return}
                    
                    for doc in querySnapshotDocs{
                        
                        let entity = EntryStruct.init(querySnapshot: doc,documentID: doc.documentID)
                        entities.append(entity)
                    }
                    
                    handler(entities,nil)
                }
            }
    }
    func stopListener(){
        listener?.remove()
    }
    
}


extension FirebaseService{
    //MARK: - Comment Processes
    
    func addNewComment(_ parentEntityID :String,comment:String){
        
        let selectedDocumentPath = entryCollection.document(parentEntityID)
        
        db.runTransaction {(transaction, errorPointer) -> Any? in
            guard let user = self.user else {return nil}
            var entryDocument:DocumentSnapshot!
            do{
                entryDocument = try transaction.getDocument(selectedDocumentPath)
            }catch let error as NSError{
                errorPointer?.pointee = error
                return nil
            }
            
            guard let oldValue = entryDocument.data()?[comments_number] as? Int else {return nil}
            transaction.updateData([comments_number:oldValue+1], forDocument: selectedDocumentPath)
            
            let commentPath = selectedDocumentPath.collection("Comments")
            let data:[String : Any] = [
                comment_text:comment,
                user_ID:user.uid,
                user_nick:user.displayName ?? "" ,
                create_date:FieldValue.serverTimestamp(),
                entry_ID:parentEntityID,
                likes_number:0,
                favorites_number:0
            ]
            
            transaction.setData(data, forDocument: commentPath.document())
            
            return nil
        } completion: { (object, error) in
            if let _ = error {
                print("comment transaction completion error\(error!.localizedDescription)")
            }
        }
        
    }
    
    func fetchComments(documentID:String,handler:@escaping ([CommentStruct],Error?)->()){
        listener = entryCollection.document(documentID).collection("Comments").addSnapshotListener({ (querySnapshot, error) in
            var comments = [CommentStruct]()
            if let error = error{
                
                handler(comments,error)
            }else{
                guard let querySnapshotDocs = querySnapshot?.documents else {return}
                for doc in querySnapshotDocs{
                    let id = doc.documentID
                    let comment = CommentStruct(snapShot: doc, commentID: id)
                    comments.append(comment)
                }
                handler(comments,nil)
                
            }
            
        })
    }
    
}

//MARK: - Comment Favorite
extension FirebaseService{
    
    func fetchFavorite(entryID:String,commentID:String, completion:@escaping (Error?)->()){
        let commentRef = entryCollection.document(entryID).collection("Comments").document(commentID)
        guard let userID = user?.uid else {return}
        commentRef
            .collection("Favorites")
            .whereField(user_ID, isEqualTo: userID)
            .addSnapshotListener({ [self] (querySnapshot, error) in
 
                if let error = error {
                    completion(error)
                }else{
                    guard let querySnapShot = querySnapshot else { return }
                    favoriteArray = FavoriteStruct.createFAvoriteArray(querySnapShot: querySnapShot)
                    if favoriteArray.count > 0{
                        cellDelegate?.decideToFavoriteImage(true)
                    }else{
                        cellDelegate?.decideToFavoriteImage(false)
                    }
                
                }
                
            })
    }
    
    
    func addorRemoveToFavorites(entryID:String,commentID:String, completion:@escaping (Error?)->()){
   
        guard let userID = user?.uid else {return}
 
        let commentRef = entryCollection.document(entryID).collection("Comments").document(commentID)
        
        db.runTransaction { [self] (transaction, errorPointer) -> Any? in
            let commentDoc: DocumentSnapshot!
            
            do{
                commentDoc =  try transaction.getDocument(commentRef)
            }catch let error as NSError{
                completion(error)
                return nil
            }
            
            //            we fetch how many user add it to favorite here
            guard let oldValue = commentDoc.data()?[favorites_number] as? Int else {return nil}
            
            if favoriteArray.count > 0{
                //  user already have added it to own favorite , user delete it from own list
              
                guard let favoriteID = favoriteArray.first?.favoriteID else { return nil}
                let favoriteRef = commentRef.collection("Favorites").document(favoriteID)
               
                transaction.updateData([favorites_number:oldValue-1], forDocument: commentRef)
                transaction.deleteDocument(favoriteRef)
                favoriteArray.removeAll()
            }else{
                //  user didn't add favorite before,it is first time
               
                let favoriteRef = commentRef.collection("Favorites").document()
                transaction.setData([user_ID : userID,
                                     comment_ID :commentDoc.documentID], forDocument: favoriteRef)
                    transaction.updateData([favorites_number:oldValue+1], forDocument: commentRef)
                    fetchFavorite(entryID: entryID, commentID: commentID) { (error) in
                        if let error = error {
                            completion(error)
                        }
                    }
            }
            return nil
            
            
        } completion: { (object, error) in
            if let error = error {
                completion(error)
            }
            
        }

    }
    
}

