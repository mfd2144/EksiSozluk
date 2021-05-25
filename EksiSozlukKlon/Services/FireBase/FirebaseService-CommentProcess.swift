//
//  FirebaseService-CommentProcess.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 15.04.2021.
//

import Foundation
import Firebase



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
            
            let commentRef = selectedDocumentPath.collection(commentsPath).document()
            let data:[String : Any] = [
                comment_text:comment,
                user_ID:user.uid,
                user_nick:user.displayName ?? "" ,
                create_date:FieldValue.serverTimestamp(),
                entry_ID:parentEntityID,
                likes_number:0,
                favorites_number:0,
                comment_ID:commentRef.documentID
            ]
            
            transaction.setData(data, forDocument: commentRef)
            
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
            query = entryCollection.document(documentID).collection(commentsPath).whereField(comment_text,in:[ keyWord!])
        }else{
            query = entryCollection.document(documentID).collection(commentsPath).order(by: create_date, descending: false)
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
    
        let commentRef = entryCollection.document(entryID).collection(commentsPath).document(commentID)
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
    
    func deleteComment(_ entryID: String, _ commentID: String,  completionHandler:@escaping (Error?)->()){
        guard  let _ = user else { return }
        
            let commentRef = entryCollection.document(entryID).collection(commentsPath).document(commentID)
            
            deleteCommentSubFiles(commentRef, subCommentCollectionName: favoritesPath) { (error) in
                if error != nil{
                    completionHandler(error)
                }else{
                    self.deleteCommentSubFiles(commentRef, subCommentCollectionName: likesPath) { (error) in
                        if error != nil{
                            completionHandler(error)
                        }else{
                            commentRef.delete { (error) in
                               
                                if error != nil{
                                    completionHandler(error)
                                }else{
                                    self.depleteOneCommentToEntry(entryID: entryID) { error in
                                        if  error != nil{
                                            completionHandler(error)
                                        }else{
                                            completionHandler(nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
            }
        
        
    }
    
    
    private func deleteCommentSubFiles(_ commentRef: DocumentReference, subCommentCollectionName:String, completionHandler: @escaping (Error?)->()){
        
        
        
        let subCommentRef = commentRef.collection(subCommentCollectionName)
        
        
        subCommentRef.limit(to: 50).getDocuments { (querySnapshot, error) in
            
            
            guard let querySnapshot = querySnapshot else{
                completionHandler(error)
                return
            }
            guard querySnapshot.count>0 else { completionHandler(nil); return }
            let batch = subCommentRef.firestore.batch()
            
            querySnapshot.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit { (error) in
                if let error = error {
                    completionHandler(error)
                }else{
                    self.deleteCommentSubFiles(commentRef, subCommentCollectionName: subCommentCollectionName, completionHandler: completionHandler)
                    
                }
            }
            
        }
        
    }
    
    func searchMyComments(docID:String,completionHandler:@escaping ([CommentStruct],Error?)->()){
        guard let user = user else{ return }
        let query = entryCollection.document(docID).collection(commentsPath).whereField(user_ID, isEqualTo: user.uid).order(by: create_date, descending: false)
    
    
        query.getDocuments(completion: { (querySnapshot, error) in
        var comments = [CommentStruct]()
        if let error = error{
            
            completionHandler(comments,error)
        }else{
            guard let querySnapshotDocs = querySnapshot?.documents else {return}
            for doc in querySnapshotDocs{
                let id = doc.documentID
                let comment = CommentStruct(snapShot: doc, commentID: id)
                
                comments.append(comment)
            }
            completionHandler(comments,nil)
            
        }
        
    })
    }
    
    
    func searchCommentsLikedByUser(docID:String,completionHandler:@escaping ([String],Error?)->()){
      var list = [String]()
        
        guard let _ = user,
              let userDocID = userDocID else{completionHandler(list,nil); return }
        
        userCollection.document(userDocID).collection("CommentLikes")
            .whereField(entry_ID, isEqualTo: docID)
            .getDocuments { querySnapshot, error in
            if let error = error{
                
                completionHandler(list,error)
            }else{
               
                guard let querySnapshotDocs = querySnapshot?.documents else {completionHandler(list,nil); return}
                for doc in querySnapshotDocs{
                 
                    let commentId = (doc[comment_ID] as? String) ?? ""
                    list.append(commentId)
                }
               completionHandler(list,nil)
            }
        }
    }
    
    func fetchCommentsByList (_ comments: [UserFavoriteStruct],handler:@escaping([CommentStruct],Error?)->()){
        var commentArray = [CommentStruct]()
    
        DispatchQueue.main.async {
            for (index,favoriteComment) in comments.enumerated(){
                self.entryCollection
                    .document(favoriteComment.entryID)
                    .collection(commentsPath)
                    .document(favoriteComment.commentID)
                    .addSnapshotListener { (documentSnapshot, error) in
                        
                        if let error = error{
                            handler(commentArray,error)
                        }else{
                            
                            let comment = CommentStruct.init(snapShot: documentSnapshot!, commentID: documentSnapshot!.documentID)
                            commentArray.append(comment)
                            
                            if index == comments.count-1{
                                handler(commentArray,nil)
                            }
                        }
                        
                    }
               
            }
            
        }
        
        
    }
    
    
}





