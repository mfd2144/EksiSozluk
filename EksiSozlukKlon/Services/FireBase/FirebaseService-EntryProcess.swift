//
//  FirebaseEntity.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 15.04.2021.
//

import Foundation
import Firebase

extension FirebaseService{
    //MARK: - Entry processes
    
    
    func addNewEntry(entry:EntryStruct ,completion:@escaping (Error?)->()){
        
        
        let collectionRef =  entryCollection.document()
        collectionRef.setData([entry_text : entry.entryLabel,
                               comments_number:entry.comments,
                               user_ID:entry.userID,
                               create_date:entry.date,
                               category_string:entry.category,
                               follow_number:entry.followNumber,
                               entry_ID:collectionRef.documentID,
                               likes_number:entry.likeNumber
                               
                               
        ]) { (error) in
            if let _ = error{
                completion(error)
            }
        }
        
        editUserEntryValue(value: 1) { (error) in
            completion(error)
        }
        
        
    }
    
    
    
    
    
    
    func fetchEntries(yesterday:Bool? = nil,today:Bool? = nil,handler:@escaping([EntryStruct],Error?)->()){
        var query:Query?
        
        if yesterday != nil && yesterday! {
            query = entryCollection.order(by: create_date, descending: true).newYesterdayWhereQuery()
        }else if today != nil && today!{
            query = entryCollection.order(by: create_date, descending: true).newTodayWhereQuery()
        }else {
            query = entryCollection.order(by: create_date, descending: true)
        }
        
        listener = query!.addSnapshotListener { (querySnapshot, error) in
            var entries = [EntryStruct]()
            if let error = error{
                handler(entries,error)
            }else{
                guard let querySnapshotDocs = querySnapshot?.documents else { handler(entries,nil)
                    return}
                
                for doc in querySnapshotDocs{
                    
                    let entry = EntryStruct.init(querySnapshot: doc,documentID: doc.documentID)
                    entries.append(entry)
                }
                
                handler(entries,nil)
            }
        }
    }
    func stopListener(){
        listener?.remove()
    }
    
    
    
    func fetchEntitiesAccordingToSettings(handler:@escaping([EntryStruct],Error?)->()){
        let settings = AgendaSettings.fetchStartingSettings()
        var searchKeys = [String]()
        let _ = settings.map{
            if $0.value == true {
                searchKeys.append($0.key)}
            
        }
        searchKeys.append("other")
        
        
        listener = entryCollection
            .order(by: create_date, descending: true)
            .whereField(category_string, in: searchKeys)
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
    
    
    
    
    
    func fetchFollowCondition(entryID:String, completion:@escaping (Error?)->()){
        guard let uid = user?.uid else {return}
        let entryRef = entryCollection.document(entryID)
        
        entryRef.collection(followerPath).whereField(user_ID,isEqualTo: uid).getDocuments {[self] (querySnapshot, error) in
            if let error = error{
                completion(error)
            }
            guard let snapShot = querySnapshot else {return}
            followArray = FollowerStruct.createFavoriteArray(querySnapShot: snapShot)
            
            if followArray.count > 0{
                
                entryDelegate?.decideToFollowCondition(true)
            }else{
                entryDelegate?.decideToFollowCondition(false)
                
                
            }
            completion(nil)
        }
        
        
    }
    
    
    
    
    
    
    
    func followUnfollowAnEntity(_ entryID:String, completion:@escaping ((Error?)->())){
        
        guard let uid = user?.uid else {return}
        let entryRef = entryCollection.document(entryID)
        
        
        db.runTransaction {[self] (transaction, _) -> Any? in
            var entryDoc:DocumentSnapshot!
            
            do{
                entryDoc = try transaction.getDocument(entryRef)
            }catch let error as NSError{
                completion(error)
                return nil
            }
            
            guard let oldNumber = entryDoc.data()?[follow_number] as? Int else {return nil}
            
            if followArray.count > 0{
                //                unfollow
                transaction.updateData([follow_number : oldNumber-1], forDocument: entryRef)
                guard let followID = followArray.first?.followID else { return nil}
                let followRef = entryRef.collection(followerPath).document(followID)
                transaction.deleteDocument(followRef)
                deleteFollowedEntryToUser(entryID: entryID)
                followArray = []
                
            }else{
                //                follow
                transaction.updateData([follow_number : oldNumber+1], forDocument: entryRef)
                let followRef = entryRef.collection(followerPath).document()
                transaction.setData([user_ID : uid,
                                     entry_ID:entryID], forDocument: followRef)
                addFollowedEntryToUser(entryID: entryID)
                followArray.append(FollowerStruct(userID: uid, entryID: entryID, followID: followRef.documentID))
            }
            
            completion(nil)
            return nil
            
        }completion: { (object, error) in
            if let error = error {
                completion(error)
            }
            
        }
        
    }
    
    
    
    
    
    func fetchEntriesByList(_ list: [String],handler:@escaping([EntryStruct],Error?)->()){
        var entries = [EntryStruct]()
        guard  list != [] else { handler(entries,nil); return }
        listener = entryCollection.whereField(entry_ID, in: list).addSnapshotListener{ (querySnapshot, error) in
            if let error = error{
                handler(entries,error)
            }else{
                
                guard let querySnapshotDocs = querySnapshot?.documents,querySnapshotDocs.count > 0 else { handler(entries,nil)
                    return}
                
                for (index,doc) in querySnapshotDocs.enumerated(){
                    
                    
                    let entry = EntryStruct.init(querySnapshot: doc,documentID: doc.documentID)
                    entries.append(entry)
                    
                    if index == querySnapshotDocs.count-1 {
                        handler(entries,nil)
                    }
        
                }
                
               
            }
        }
        
    }
    
    
    func depleteOneCommentToEntry(entryID:String,handler:@escaping ((Error?)->())){
        
        
        let entryRef = entryCollection.document(entryID)
        db.runTransaction { (transaction, errorPoint) -> Any? in
            var entryDoc: DocumentSnapshot!
            
            do{
                entryDoc = try transaction.getDocument(entryRef)
                
            }catch{
                handler(error)
            }
            
            guard let oldValue = entryDoc.data()?[comments_number] as? Int else { return nil}
            
            transaction.updateData ([comments_number : oldValue - 1 ], forDocument: entryRef)
            return nil
            
        } completion: { (_, error) in
            if let _ = error {
                handler(error!)
            }
        }
        
        
        
    }
    
    func searchInEntries(with keyWord:String,completionHandler:@escaping ([MostLikedStruct],Error?)->()){
        var mostFollowedEntries = [MostLikedStruct]()
        var entries = [EntryStruct]()
        entryCollection.whereField(entry_text,arrayContains: keyWord).getDocuments { querySnapshot, error in
            if let error = error {
                completionHandler(mostFollowedEntries,error)
                return
            }else{
                guard let resultSnapShot = querySnapshot else {
                    completionHandler(mostFollowedEntries,nil)
                    return
                }
                for doc in resultSnapShot.documents{
                    
                    let entry = EntryStruct(querySnapshot: doc, documentID: doc.documentID)
                    entries.append(entry)
                }
                
                var  otherEntries = MostLikedStruct(category: "other", entries: [EntryStruct]())
                var entertainmentEntries = MostLikedStruct(category: "entertainment", entries: [EntryStruct]())
                var sportEntries = MostLikedStruct(category: "sport", entries: [EntryStruct]())
                var relationEntries =  MostLikedStruct(category: "relation", entries: [EntryStruct]())
                var politicialEntries =  MostLikedStruct(category: "political", entries: [EntryStruct]())
                
                
                entries.forEach({
                    switch $0.category{
                    case "sport": sportEntries.entries.append($0)
                    case "entertainment":entertainmentEntries.entries.append($0)
                    case "relation":relationEntries.entries.append($0)
                    case "political":politicialEntries.entries.append($0)
                    default:otherEntries.entries.append($0)
                    }
                })
                
                mostFollowedEntries = [otherEntries,sportEntries,relationEntries,politicialEntries,entertainmentEntries]
                
                
                
                
                completionHandler(mostFollowedEntries,nil)
                
            }
        }
    }
    
    
}



extension FirebaseService{
    
    func fetchLikeCondition(entryID:String, completion:@escaping (Error?)->()){
        
        guard let uid = user?.uid else {return}
        let entryRef = entryCollection.document(entryID)
        
        entryRef.collection(likesPath).whereField(user_ID,isEqualTo: uid).getDocuments{[self] (querySnapshot, error) in
            if let error = error{
                completion(error)
            }
            guard let snapShot = querySnapshot else {return}
            entryLikesArray = LikeStruct.createLikeArray(querySnapShot: snapShot)
            if entryLikesArray.count > 0{
                entryDelegate?.decideToEntryLikeCondition(true)
            }else{
                entryDelegate?.decideToEntryLikeCondition(false)
            }
        }
        
        
    }
    
    
    
    func likeOrUnlikeAnEntity(_ entryID:String, completion:@escaping ((Error?)->())){
        
        guard let uid = user?.uid else {return}
        let entryRef = entryCollection.document(entryID)
        
        
        db.runTransaction {[self] (transaction, _) -> Any? in
            var entryDoc:DocumentSnapshot!
            
            do{
                entryDoc = try transaction.getDocument(entryRef)
            }catch let error as NSError{
                completion(error)
                return nil
            }
            
            guard let oldNumber = entryDoc.data()?[likes_number] as? Int else {completion(nil) ; return nil}
            
            if entryLikesArray.count > 0{
                //                unfollow
                transaction.updateData([likes_number : oldNumber-1], forDocument: entryRef)
                guard let likeID = entryLikesArray.first?.likeID else { return nil}
                let likeRef = entryRef.collection(likesPath).document(likeID)
                transaction.deleteDocument(likeRef)
                deleteEntryLikeToUser(entryID: entryID)
                entryLikesArray = []
                
            }else{
                //                follow
                transaction.updateData([likes_number : oldNumber+1], forDocument: entryRef)
                let likeRef = entryRef.collection(likesPath).document()
                transaction.setData([user_ID : uid,
                                     entry_ID:entryID], forDocument: likeRef)
                addLikedEntryToUser(entryID: entryID)
                entryLikesArray.append(LikeStruct(userID: uid, commentID:entryID , likeID: likeRef.documentID))
                //                doesn't create another like struct for entry , I use comment like struct.Thus commentID means entryID here
            }
            
            completion(nil)
            return nil
            
        }completion: { (object, error) in
            if let error = error {
                completion(error)
            }
            
        }
    }
    
    func searchMyEntries(handler:@escaping([EntryStruct],Error?)->()){
        var entries = [EntryStruct]()
        guard let user = user else {handler(entries,nil); return}
        entryCollection.whereField(user_ID, isEqualTo: user.uid).getDocuments { querySnapshot, error in
            if let error = error{
                handler(entries,error)
                return
            }else{
                guard let entriesSnapshot = querySnapshot?.documents else { handler(entries,nil); return}
                for doc in entriesSnapshot{
                    let entry = EntryStruct.init(querySnapshot: doc, documentID: doc.documentID)
                    entries.append(entry)
                }
                handler(entries,nil)
                
            }
        }
    }
    
    
    
    func fetchRookiesEntries(handler:@escaping ([EntryStruct],Error?)->()){
        var users = [String]()
        let entries = [EntryStruct]()
        userCollection
            .whereField(user_total_entity, isGreaterThan: 10)
            .whereField(user_total_entity, isLessThan: 30)
            .getDocuments { querySnapshot, error in
                if let error = error{
                    handler(entries,error)
                }else{
                    guard  let usersQuery = querySnapshot?.documents else {  handler(entries,nil); return }
                    
                    
                    for (index,userQuery) in usersQuery.enumerated(){
                        guard let user = userQuery.data()[user_ID] as? String else {  handler(entries,nil);return }
                        users.append(user)
                                            
                        if index == usersQuery.count-1{
                            self.fetchEntriesByRookies(users){ sendedEntries, error in
                                    handler(sendedEntries,error)
                        }
                    }
                }
            }
        
    }
    }
    
    private func fetchEntriesByRookies(_ users:[String],handler:@escaping (([EntryStruct],Error?)->())){
        entryCollection
            .whereField(user_ID, in:users)
            .order(by: likes_number, descending: true)
            .getDocuments { querySnapshot, error in
                if let error = error{
                    handler([EntryStruct](),error)
                }else{
                    var entries=[EntryStruct]()
                    guard let entriesQuery = querySnapshot?.documents else {handler(entries,nil) ;return}
                    for entry in entriesQuery{
                        let entry = EntryStruct.init(querySnapshot: entry, documentID: entry.documentID)
                        entries.append(entry)
                    }
                    handler(entries,nil)
            }
    }
    
}
    
    
    func fetchFollowedUserEntry(handler:@escaping([EntryStruct],Error?)->()){
        var entries = [EntryStruct]()
        var followedUsers = [FollowedUser]()
        guard  let userDocId = userDocID else { return }
        
        userCollection.document(userDocId).collection(followedUserPath).getDocuments { querySnapshot, error in
            if let error = error {
                handler(entries,error)
            }else{
                guard let resultQuery = querySnapshot?.documents else {handler(entries,nil);return}
                for (index,followedUser) in resultQuery.enumerated(){
                    guard let user = FollowedUser.init(followedUser) else {handler(entries,nil);return}
                    followedUsers.append(user)
                    if index == resultQuery.count-1{
                        followedUsersNewEntryFetcher(followedUsers){ result,error in
                            if let error = error{
                                handler(entries,error)
                            }else{
                                handler(result,error)
                            }
                        }
                    }
                }
                
                
            }
        }
        
        
        
        func followedUsersNewEntryFetcher(_ users:[FollowedUser],handler:@escaping([EntryStruct],Error?)->()){
            
            for (index,user) in users.enumerated(){
                
                entryCollection
                    .whereField(user_ID, isEqualTo: user.userID)
                    .whereField(create_date, isGreaterThanOrEqualTo: user.createDate)
                    .getDocuments { querySnapshot, error in
                        if let error = error{
                            handler(entries,error)
                        }else{
                            guard let resultQuery = querySnapshot?.documents else {return}
                            for entrySnap in resultQuery{
                                let entry = EntryStruct.init(querySnapshot: entrySnap, documentID: entrySnap.documentID)
                                entries.append(entry)
                            }
                            if users.count-1 == index{
                                handler(entries,nil)
                            }
                        }
                    }
            }
        }
    }

    
    

}





