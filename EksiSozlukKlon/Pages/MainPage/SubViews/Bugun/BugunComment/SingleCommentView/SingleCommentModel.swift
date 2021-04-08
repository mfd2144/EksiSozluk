//
//  SingleCommentModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 6.04.2021.
//

import UIKit
import Firebase


class SingleCommentModel:NSObject{
    
    let firebaseService=FirebaseService()
    var comment:CommentStruct?{
        didSet{
            fetchFavorite()
        }
    }
    
    override init() {
        super.init()
    }
    
   private func fetchFavorite(){
        guard let comment = comment else {return}
        firebaseService.fetchFavoriteCondition(entryID: comment.entryID, commentID: comment.commentID) { (error) in
            if let error = error{
                print("fetching favorite data error \(error) ")
            }
        }
            firebaseService.fetchSingleCommentNumber(entryID: comment.entryID, commentID: comment.commentID) { (error) in
                if let error = error{
                    print("fetching favorite number error \(error) ")
                }
    }
    firebaseService.fetchlikeCondition(entryID: comment.entryID, commentID: comment.commentID) {(error) in
        if let error = error{
            print("fetching like number error \(error) ")
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
    
    func addorRemoveLikes(){

        guard let comment = comment else {return}
        firebaseService.addorRemoveFromLike(entryID: comment.entryID, commentID: comment.commentID) { (error) in
           
            if let error = error{
                print(error.localizedDescription)
        }
        }
    }
    
    func newAlertView()->UIAlertController{
        let alertView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionSendMessage = UIAlertAction(title: "mesaj gönder", style: .default) { (actionSendMes) in
            print("send a message")
        }
        let actionBlockUser = UIAlertAction(title: "yazarı engelle", style: .default) { (actionBlock) in
            print("yazarı engelle")
        }
        let actionCompliant = UIAlertAction(title: "şikayet et", style: .default) { (actionComp) in
            print("şikayet et")
        }
        let actionCancel = UIAlertAction(title: "vazgeç", style: .cancel)
        alertView.addAction(actionSendMessage)
        alertView.addAction(actionBlockUser)
        alertView.addAction(actionCompliant)
        alertView.addAction(actionCancel)
        return alertView
    }
    
    
}
