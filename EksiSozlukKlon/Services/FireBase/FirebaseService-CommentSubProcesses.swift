//
//  FirebaseService-CommentSubProcesses.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 15.04.2021.
//

import Foundation
import Firebase

extension FirebaseService{
    
    func fetchFavoriteCondition(entryID:String,commentID:String, completion:@escaping (Error?)->()){
        
        let commentRef = entryCollection.document(entryID).collection(commentsPath).document(commentID)
        guard let userID = user?.uid else {return}
        commentRef
            .collection(favoritesPath)
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
        
        let commentRef = entryCollection.document(entryID).collection(commentsPath).document(commentID)
        
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
                let favoriteRef = commentRef.collection(favoritesPath).document(favoriteID)
                transaction.updateData([favorites_number:oldValue-1], forDocument: commentRef)
                transaction.deleteDocument(favoriteRef)
                favoriteArray.removeAll()
                
                removeUserFavoriteList(commentID)
                
                
            }else{
                //  user didn't add favorite before,it is first time
                
                let favoriteRef = commentRef.collection(favoritesPath).document()
               
                
                transaction
                    .setData([user_ID : userID,
                                     comment_ID :commentDoc.documentID], forDocument: favoriteRef)
                
                transaction.updateData([favorites_number:oldValue+1], forDocument: commentRef)
                
                addUserFavoriteList(commentID,entryID: entryID)
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
        
        let commentRef = entryCollection.document(entryID).collection(commentsPath).document(commentID)
        
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
                let likeRef = commentRef.collection(likesPath).document(likeID)
                
                transaction.updateData([likes_number:oldValue-1], forDocument: commentRef)
                transaction.deleteDocument(likeRef)
                likeArray.removeAll()
             
                
            }else{
                //  user didn't push like before,it is first time
                
                let likeRef = commentRef.collection(likesPath).document()
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
        
        let commentRef = entryCollection.document(entryID).collection(commentsPath).document(commentID)
        guard let userID = user?.uid else {return}
        commentRef
            .collection(likesPath)
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

