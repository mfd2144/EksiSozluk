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
    func decideToLikeImage(_ fill:Bool)
    func listenSingleComment(_comment:CommentStruct)
}

class FirebaseService:NSObject{
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    lazy var userCollection = db.collection("User")
    lazy var entryCollection = db.collection("Entry")
    var listener :ListenerRegistration?
    var authStatus :((Status)->())?
    var favoriteArray = [FavoriteStruct]()
    var likeArray = [LikeStruct]()
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
                                           create_date:entry.date,
                                           categoryString:entry.category
        ]) { (error) in
            if let _ = error{
                print("entity could't be created  \(error!.localizedDescription)")
            }
        }
    }
    
    func fetchEntities(yesterday:Bool? = nil,today:Bool? = nil,handler:@escaping([EntryStruct],Error?)->()){
        var query:Query?
        
        if yesterday != nil && yesterday! {
            query = entryCollection.order(by: create_date, descending: true).newYesterdayWhereQuery()
        }else if today != nil && today!{
            query = entryCollection.order(by: create_date, descending: true).newTodayWhereQuery()
        }else {
            query = entryCollection.order(by: create_date, descending: true)
        }

        listener = query!.addSnapshotListener { (querySnapshot, error) in
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
    


    func fetchEntitiesAccordingToSettings(handler:@escaping([EntryStruct],Error?)->()){
        let settings = GundemSettings.fetchStartingSettings()
        var searchKeys = [String]()
        let _ = settings.map{
            if $0.value == true {
                searchKeys.append($0.key)}
        }
        searchKeys.append("diğer")
    

        listener = entryCollection
            .order(by: create_date, descending: true)
            .whereField(categoryString, in: searchKeys)
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

    func fetchComments(documentID:String,keyWord:String? = nil,handler:@escaping ([CommentStruct],Error?)->()){
        
        let query:Query?
        
        if keyWord != nil {
            query = entryCollection.document(documentID).collection("Comments").whereField(comment_text,in:[ keyWord!])
        }else{
            query = entryCollection.document(documentID).collection("Comments").order(by: create_date, descending: false)
        }
        
        listener = query!.addSnapshotListener({ (querySnapshot, error) in
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
    
    func fetchCommentListener(entryID:String,commentID:String, completion:@escaping (Error?)->()){

        let commentRef = entryCollection.document(entryID).collection("Comments").document(commentID)
       commentRef.addSnapshotListener({ [self] (querySnapshot, error) in

                if let error = error {
                    completion(error)
                }else{
                    guard let commentQuery = querySnapshot else {return}
                   let comment = CommentStruct.init(snapShot: commentQuery, commentID: commentQuery.documentID)
                    cellDelegate?.listenSingleComment(_comment: comment)
                    
                }

            })
    }
    
}

//MARK: - Comment Favorite
extension FirebaseService{
    
    func fetchFavoriteCondition(entryID:String,commentID:String, completion:@escaping (Error?)->()){
       
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
                    favoriteArray = FavoriteStruct.createFavoriteArray(querySnapShot: querySnapShot)
            
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
            }
            return nil
            
            
        } completion: { (object, error) in
            if let error = error {
                completion(error)
            }
            
        }

    }

    
    
    func addorRemoveFromLike(entryID:String,commentID:String, completion:@escaping (Error?)->()){
     
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
            guard let oldValue = commentDoc.data()?[likes_number] as? Int else {return nil}
            
            if likeArray.count > 0{
                //  user already have pushed like button , user delete it from own list
              
                guard let likeID = likeArray.first?.LikeID else { return nil}
                let likeRef = commentRef.collection("Likes").document(likeID)
               
                transaction.updateData([likes_number:oldValue-1], forDocument: commentRef)
                transaction.deleteDocument(likeRef)
                likeArray.removeAll()
            }else{
                //  user didn't push like before,it is first time
               
                let likeRef = commentRef.collection("Likes").document()
                transaction.setData([user_ID : userID,
                                     comment_ID :commentDoc.documentID], forDocument: likeRef)
                    transaction.updateData([likes_number:oldValue+1], forDocument: commentRef)
                    
                    
            }
            return nil
            
            
        } completion: { (object, error) in
            if let error = error {
                completion(error)
            }
            
        }

    }
    func fetchlikeCondition(entryID:String,commentID:String, completion:@escaping (Error?)->()){
       
        let commentRef = entryCollection.document(entryID).collection("Comments").document(commentID)
        guard let userID = user?.uid else {return}
        commentRef
            .collection("Likes")
            .whereField(user_ID, isEqualTo: userID)
            .addSnapshotListener({ [self] (querySnapshot, error) in

                if let error = error {
                    completion(error)
                }else{
                    guard let querySnapShot = querySnapshot else { return }
                    likeArray = LikeStruct.createLikeArray(querySnapShot: querySnapShot)
                    if likeArray.count > 0{
                        cellDelegate?.decideToLikeImage(true)
                    }else{
                        cellDelegate?.decideToLikeImage(false)
                    }

                }

            })
    }
    
}

