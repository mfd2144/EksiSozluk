//
//  SingleCommentModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 6.04.2021.
//

import Foundation
import Firebase


class SingleCommentModel:NSObject{
    
    let firebaseService=FirebaseService()
    
    override init() {
        super.init()
    }
    
    func addorRemoveToFavorites(comment:CommentStruct){
        
        firebaseService.addorRemoveToFavorites(entryID: comment.entryID, commentID: comment.commentID) { (error) in
            if let error = error{
                print(error.localizedDescription)
        }
        }
        
        
    }
    
    
    
}
