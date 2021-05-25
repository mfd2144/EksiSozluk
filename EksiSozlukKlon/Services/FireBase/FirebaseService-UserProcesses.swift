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
                                 user_email:userInfo.email,
                                 create_date: userInfo.createDate,
                                 user_birthday: userInfo.birtday as Any,
                                 user_gender:userInfo.gender,
                                 user_ID :currentUser.uid,
                                 user_docID:newUser.documentID,
                                 user_total_entity:userInfo.totalEntry,
                                 user_total_contact :userInfo.totalContact,
                                 
                ])
                { error in
                    self.getUserDocID(){ }
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
    
    func fetchUserInformation(handler:@escaping(UserStruct?,Error?)->() ){
        guard let userDocID = userDocID else {handler(nil,nil);return}
        userCollection.document(userDocID).getDocument { docSnapshot, error in
            if let error = error {
                handler(nil,error)
            }else{
                guard let userSnapshot = docSnapshot?.data() else { handler(nil,nil);return }
                let user = UserStruct.init(userSnapshot)
                handler(user,nil)
            }
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
    
    func getUserDocID(handler:@escaping()->()){
        
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
            handler()
            
        }
    }
    
    func addFollowedEntryToUser(entryID:String){
        guard let docID = userDocID else {  return  }
        self.userCollection.document(docID).collection(followedPath).addDocument(data: [entry_ID:entryID]){ error in
            if let error = error  {
                print("adding followed list error \(error.localizedDescription)")
            }
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
                        print("followed list delete error \(error.localizedDescription)")
                        
                    }
                }
            })
    }
    
    func deleteEntryLikeToUser(entryID:String){
        
        guard let docID = userDocID else {return}
        
        self.userCollection.document(docID)
            .collection(likesPath)
            .whereField(entry_ID, isEqualTo: entryID)
            .getDocuments(completion: { (querySnapshot, error) in
                guard let likeID = querySnapshot?.documents.first?.documentID else {return}
                
                self.userCollection.document(docID).collection(likesPath).document(likeID).delete { (error) in
                    if let error = error  {
                        print(" like erase error \(error.localizedDescription)")
                        
                    }
                }
            })
    }
    
    func addLikedEntryToUser(entryID:String){
        guard let docID = userDocID else {  return  }
        self.userCollection.document(docID).collection(likesPath).addDocument(data: [entry_ID:entryID]){ error in
            if let error = error  {
                print("adding liked list error \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    
    //    if user demand nothing this function return favorite entries list otherwise like entries list
    func fetchUserDemandedList(_ likeList:Bool? = nil,completion:@escaping ([String],Error?)->()){
        var demandedEntryList = [String]()
        guard let docID = userDocID else {  completion(demandedEntryList,nil); return  }
        
        var query:Query?
        if likeList != nil{
            query = userCollection.document(docID).collection(likesPath)
        }else{
            query = userCollection.document(docID).collection(followedPath)
        }
        
        query!.getDocuments { (querySnapshot, error) in
            if let error = error  {
                
                completion(demandedEntryList,error)
                
            }else{
                guard let docs = querySnapshot?.documents else {  completion(demandedEntryList,nil); return }
                for doc in docs{
                    demandedEntryList.append(doc[entry_ID] as? String ?? "")
                }
                completion(demandedEntryList,nil)
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
            
            guard userDoc != nil, let oldValue = userDoc.data()?[user_total_entity] as? Int else {return nil}
            
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
        
        userCollection.whereField(user_nick, isGreaterThanOrEqualTo: keyWord).whereField(user_nick, isNotEqualTo: user?.displayName ?? "").getDocuments { (querys, error) in
            if let error = error{
                handler(users,error)
            }else{
                users = BasicUserStruct.getUsersForSeach(querys)
                
                handler(users,nil)
            }
        }
    }
    
    func checkUserInList(otherUserId:String,handler:@escaping(Bool,Error?)->()){
        guard  let userDocID = userDocID else {handler(false,nil);return}
        
        let userFollowedRef = userCollection.document(userDocID).collection(followedUserPath).whereField(followed_user_id, isEqualTo: otherUserId)
        userFollowedRef.getDocuments { querySnapshot,error in
            if let error = error {
                handler(false,error)
            }else{
                if querySnapshot?.documents.first?.data() != nil{
                    handler(true,nil)
                }else{
                    handler(false,nil)
                }
            }
        }
    }
    
    
    func addUserToFollowList(otherUserId:String,handler:@escaping(Error?)->()){
        guard  let userDocID = userDocID else {handler(nil);return}
        
        let userRef = userCollection.document(userDocID)
        db.runTransaction { transaction, _ in
            var userDoc:DocumentSnapshot?
            do{
                userDoc = try transaction.getDocument(userRef)
            }catch let error{
                handler(error)
            }
            guard let contactNumber = userDoc?.data()?[user_total_contact] as? Int else{handler(nil);return nil}
            transaction.updateData([user_total_contact:contactNumber+1], forDocument: userRef)
            
            let  userFollowedRef = userRef.collection(followedUserPath).document()
            transaction.setData([followed_user_id : otherUserId,
                                 "follow_date":FieldValue.serverTimestamp(),
                                 "pathID":userFollowedRef.documentID], forDocument: userFollowedRef)
            
            return nil
        } completion: { _, error in
            handler(error)
        }
        
        
        
        
        
    }
    
    func deleteUserFromFollowList(otherUserId:String,handler:@escaping(Error?)->()){
        
        guard  let userDocID = userDocID else {handler(nil);return}
        
        
        let userRef = userCollection.document(userDocID)
        
        userRef.collection(followedUserPath).whereField(followed_user_id,isEqualTo: otherUserId).getDocuments { querySnapshot, error in
            if let error = error {
                handler(error)
            }else{
                guard let followedUserDocID = querySnapshot?.documents.first?.documentID else { return }
                self.db.runTransaction { transaction, _ in
                    var userDoc:DocumentSnapshot?
                    do{
                        userDoc = try transaction.getDocument(userRef)
                    }catch let error{
                        handler(error)
                    }
                    guard let contactNumber = userDoc?.data()?[user_total_contact] as? Int else{handler(nil);return nil}
                    transaction.updateData([user_total_contact:contactNumber-1], forDocument: userRef)
                    let willDeletedRef = userRef.collection(followedUserPath).document(followedUserDocID)
                    transaction.deleteDocument(willDeletedRef)
                    
                    return nil
                } completion: { _, error in
                    handler(error)
                }
                
                
            }
            
        }
        
        
    }
    
    
    func resetUserLastUpdateDate(handler:@escaping (Error?)->()){
        guard let userDocId = userDocID else {return}
        let ref = userCollection.document(userDocId).collection(followedUserPath)
        ref.getDocuments { querySnapshot, error in
            if let error = error {
                handler(error)
            }else{
                guard let followedUserSnapshot = querySnapshot else { return }
                let batch = ref.firestore.batch()
                followedUserSnapshot.documents.forEach {batch.updateData([followed_date:FieldValue.serverTimestamp()], forDocument: $0.reference)}
                batch.commit { error in
                    if let error = error{
                        handler(error)
                    }else{
                        handler(nil)
                    }
                }
                
            }
            
            
        }
    }
    
    func sendPasswordReset(email:String,handler:@escaping (Error?)->()){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error{
                handler(error)
            }else{
                handler(nil)
            }
        }
    }
    
    func  changePassword(newPassword:String,handler:@escaping (Error?)->()) {
        user?.updatePassword(to: newPassword) { error in
            if let error = error{
                handler(error)
            }else{
                handler(nil)
            }
        }
    }
    
    func resetMailAdress(newMail:String,handler:@escaping (Error?)->()){
        user?.updateEmail(to: newMail) {error in
            if let error = error{
                handler(error)
            }else{
                
                self.updateUserInformation(nick: nil, userBirtday: nil, gender: nil, email: newMail) { error in
                    if let error = error {
                        handler(error)
                    }else{
                        handler(nil)
                    }
                    
                }
               
            }
        }
    }
    
    func updateUserInformation(nick:String?,userBirtday:Date?,gender:Int?,email:String?,handler:@escaping (Error?)->()){
        
        guard let userDocID=userDocID else{return}
        let ref = userCollection.document(userDocID)
        db.runTransaction { transaction, _ in
            var userDoc:DocumentSnapshot!
            
            do{
                userDoc = try transaction.getDocument(ref)
            }catch let error{
                handler(error)
                return nil
            }
            guard let data = userDoc.data(),let userInfo = UserStruct(data) else {return nil}
            
                        
            transaction.updateData([user_nick : nick ?? userInfo.nick,
                                    user_birthday: userBirtday ?? userInfo.birtday as Any,
                                    user_gender: gender ?? userInfo.gender,
                                    user_email:email ?? userInfo.email], forDocument: ref)
            
            
            return nil
        } completion: { _, error in
            if let error = error{
                handler(error)
            }
        }

    }
    
}


