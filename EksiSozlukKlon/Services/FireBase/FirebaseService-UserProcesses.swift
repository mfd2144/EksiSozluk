//
//  FirebaseService-UserProcesses.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 15.04.2021.
//

import Foundation
import Firebase





extension FirebaseService{
    
    func createUser(userInfo:UserStruct,handler:@escaping ((String,Error?)->())) {
        guard let password = userInfo.password else {
            handler("password is needed",nil)
            return }
        userCollection.whereField(user_nick, isEqualTo: userInfo.nick).getDocuments { (querySnapshot, error) in
            if let error = error{
                handler("fetching users document ID error",error)
            }
            
            if querySnapshot?.documents.first == nil{
                Auth.auth().createUser(withEmail: userInfo.email, password: password) { authResult, error in
                    if let error = error {
                        handler("adding new user error",error)
                        
                    }else{
                        let changeRequest = authResult?.user.createProfileChangeRequest()
                        changeRequest?.displayName = userInfo.nick
                        changeRequest?.commitChanges(completion: { (error) in
                            if let _ = error {
                                handler("adding new users information error",error)
                            }
                            guard let currentUser = authResult?.user else {return}
                            self.saveNewUsersInfo(userInfo,currentUser)
                            handler("kullanıcı başarıyla kaydedildi",nil)
                        })
                    }
                }
                
                
                
                
            }else{
                handler("kullanıcı mevcut",nil)
            }
            
        }
        
        
        
        
        
        
        
        
    }
    
    func saveNewUsersInfo(_ userInfo: UserStruct,_ currentUser:User){
        
        userCollection.whereField(user_ID, isEqualTo: currentUser.uid).getDocuments { (querySnapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            if querySnapshot?.documents.first == nil{
                
                let newUser = self.userCollection.document()
            
                newUser.setData([user_nick : userInfo.nick,
                                 create_date: userInfo.createDate,
                                 user_birthday: userInfo.birtday as Any,
                                 user_gender:userInfo.gender,
                                 user_ID :currentUser.uid,
                                 user_docID:newUser.documentID,
                                 user_total_entity:userInfo.totalEntity,
                                 user_total_contact :userInfo.totalContact,
                                 
                ])
                { error in
                    self.getUserDocID()
                    guard let _ = error else {return}
                    print("User information couldn't be added \(error!.localizedDescription)")
                }
                
            }
        }
        
        
    }
    
    func userSignIn(_ email:String,_ password:String){
        Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
            if let error = error {
                print(error)
            }else{
                self.authStatus?(.login)
            }
        }
    }
    
    func credentialLogin(_ credential:AuthCredential){
       
        Auth.auth().signIn(with: credential) { (authDataResult, error) in
            if let error = error {
                print("while opening google user,an error ocurred \(error.localizedDescription)")
            }
            
            guard let userInfo = authDataResult?.user else {return}
            let changeRequest = userInfo.createProfileChangeRequest()
            changeRequest.displayName = userInfo.displayName?.lowercased()
            changeRequest.commitChanges(completion: { (error) in
                if let _ = error {
                    print("while opening google user,an error ocurred \(error!.localizedDescription)")
                }
                })

            let email = userInfo.email?.lowercased()
            let nick = userInfo.displayName?.lowercased()
            let gender = 3 //boşver/empty
            
            let user = UserStruct(email: email!, nick: nick!, password: nil, gender: gender, birthday:nil)
         
            guard let currentUser = Auth.auth().currentUser else {return}
            
            self.saveNewUsersInfo(user,currentUser )
        }
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
    
    func getUserDocID(){
        
        user = Auth.auth().currentUser
        
        guard let uid = user?.uid else {  return }
        
        userCollection.whereField(user_ID, isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error{
                
                print("fetching user document ID error \(error.localizedDescription)")
                return
            }
            guard let docID = querySnapshot?.documents.first?.data()[user_docID] as? String else {return}
            
            let singleton = AppSingleton.shared
            
            singleton.userDocID = docID
            
        }
    }
    
    
    func deleteFollowedEntryToUser(entryID:String){
        
        guard let docID = userDocID else {return}
        
        self.userCollection.document(docID)
            .collection(followedPath)
            .whereField(entry_ID, isEqualTo: entryID)
            .getDocuments(completion: { (querySnapshot, error) in
                guard let followID = querySnapshot?.documents.first?.documentID else {return}
                
                self.userCollection.document(docID).collection(followedPath).document(followID).delete { (error) in
                    if let error = error  {
                        print("deleting followed list error \(error.localizedDescription)")
                        
                    }
                }
            })
    }
    
    
    
    func addFollowedEntryToUser(entryID:String){
        guard let docID = userDocID else {  return  }
        self.userCollection.document(docID).collection(followedPath).addDocument(data: [entry_ID:entryID]){ error in
            if let error = error  {
                print("adding followed list error \(error.localizedDescription)")
            }
        }
    }
    
    
    func fetchUserFollowList(completion:@escaping ([String],Error?)->()){
        var followedEntryList = [String]()
        guard let docID = userDocID else {  completion(followedEntryList,nil); return  }
        
        userCollection.document(docID).collection(followedPath).getDocuments { (querySnapshot, error) in
            if let error = error  {
                
                completion(followedEntryList,error)
                
            }else{
                
                guard let docs = querySnapshot?.documents else {  completion(followedEntryList,nil); return }
                for doc in docs{
                    followedEntryList.append(doc[entry_ID] as? String ?? "")
                }
                completion(followedEntryList,nil)
            }
            
            
            
        }
        
        
    }
    
    func addUserFavoriteList(_ commentID:String,entryID:String){
        guard let docID = userDocID else {  return  }
        self.userCollection
            .document(docID)
            .collection(favoritesPath)
            .addDocument(data: [entry_ID:entryID,
                                comment_ID:commentID]){ error in
                if let error = error  {
                    print("adding favorite from list error \(error.localizedDescription)")
                }
            }    }
    
    
    
    func removeUserFavoriteList(_ commentID:String){
        
        guard let docID = userDocID else {return}
        
        self.userCollection.document(docID)
            .collection(favoritesPath)
            .whereField(comment_ID, isEqualTo: commentID)
            .getDocuments(completion: { (querySnapshot, error) in
                guard let favoriteID = querySnapshot?.documents.first?.documentID else {return}
                
                self.userCollection.document(docID).collection(favoritesPath).document(favoriteID).delete { (error) in
                    if let error = error  {
                        print("deleting favorite from list error \(error.localizedDescription)")
                        
                    }
                }
            })    }
    
    
    
    func fetchUserFavoriteList(completion:@escaping ([UserFavoriteStruct],Error?)->()){
        var followedFavoriteList = [UserFavoriteStruct]()
        guard let docID = userDocID else {  completion(followedFavoriteList,nil); return  }
        
        userCollection.document(docID).collection(favoritesPath).getDocuments { (querySnapshot, error) in
            if let error = error  {
                
                completion(followedFavoriteList,error)
                
            }else{
                
                guard let docs = querySnapshot?.documents else {  completion(followedFavoriteList,nil); return }
                for doc in docs{
                    followedFavoriteList.append(UserFavoriteStruct.init(doc))
                }
                completion(followedFavoriteList,nil)
            }
            
            
            
        }
        
        
    }
    
    
    func editUserEntryValue(value:Int,handler:@escaping ((Error?)->())){
        
        let userRef = userCollection.document(userDocID!)
        db.runTransaction { (transaction, errorPoint) -> Any? in
            var userDoc: DocumentSnapshot!
            
            do{
                userDoc = try transaction.getDocument(userRef)
            }catch{
                handler(error)
            }
            
            guard let oldValue = userDoc.data()?[user_total_entity] as? Int else {return nil}
            
            transaction.updateData([user_total_entity:oldValue + value], forDocument:userRef )
            
            
            
            return nil
        } completion: { (_, error) in
            if let _ = error {
                handler(error!)
            }
        }
        
        
        
    }
    
    
    
    func deleteUser(completionHandler:@escaping (Error?)->()){
        guard  let _ = user, let _ = userDocID  else { return }
        
        deleteUserSubFiles(subFileCollectionName: favoritesPath) {[self] (error) in
            if let error = error{
                completionHandler(error)
            }else{
                deleteUserSubFiles(subFileCollectionName: followedPath) { (error) in
                    if let error = error{
                        completionHandler(error)
                    }else{
                        deleteUserSubFiles(subFileCollectionName: contactsPath) { (error) in
                            if let error = error{
                                completionHandler(error)
                            }else{
                                userCollection.document(userDocID!).delete { (error) in
                                    if let error = error{
                                        completionHandler(error)
                                    }else{
                                        user?.delete(completion: { (error) in
                                            if let error = error{
                                                completionHandler(error)
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func deleteUserSubFiles(subFileCollectionName:String,completionHandler:@escaping (Error?)->()){
        
        let subUserRef = userCollection.document(userDocID!).collection(subFileCollectionName)
        subUserRef.limit(to: 50).getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else{
                completionHandler(error)
                return
            }
            
            guard querySnapshot.count>0 else { completionHandler(nil); return }
            let batch = subUserRef.firestore.batch()
            
            querySnapshot.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit { (error) in
                if let error = error {
                    completionHandler(error)
                }else{
                    self.deleteUserSubFiles(subFileCollectionName: subFileCollectionName, completionHandler: completionHandler)
                }
            }
            
        }
    }
    
    func searchForUser(keyWord:String,handler:@escaping (([BasicUserStruct],Error?)->())){
        var users = [BasicUserStruct]()
        
        listener =  userCollection.whereField(user_nick, isGreaterThanOrEqualTo: keyWord).whereField(user_nick, isNotEqualTo: user?.displayName ?? "").addSnapshotListener { (querys, error) in
            if let error = error{
                handler(users,error)
            }else{
                users = BasicUserStruct.getUsersForSeach(querys)
                
                handler(users,nil)
            }
        }
    }
    
    
    
}

