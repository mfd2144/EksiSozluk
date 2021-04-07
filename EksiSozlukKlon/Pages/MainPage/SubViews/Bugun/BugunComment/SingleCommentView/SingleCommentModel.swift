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
    var comment:CommentStruct?{
        didSet{
            fetchFavorite()
            print("çalıştı")
        }
    }
    
    override init() {
        super.init()
    }
    
   private func fetchFavorite(){
        guard let comment = comment else {return}
        firebaseService.fetchFavorite(entryID: comment.entryID, commentID: comment.commentID) { (error) in
            if let error = error{
                print("fetching favorite data error \(error) ")
            }
        }
    }
    
    func addorRemoveToFavorites(){
        guard let comment = comment else {return}
        firebaseService.addorRemoveToFavorites(entryID: comment.entryID, commentID: comment.commentID) { (error) in
            if let error = error{
                print(error.localizedDescription)
        }
        }
        
        
    }
    
    
    
}
