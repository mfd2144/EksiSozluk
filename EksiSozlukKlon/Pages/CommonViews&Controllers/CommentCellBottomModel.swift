//
//  File.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 9.04.2021.
//

import UIKit


protocol CommentCellBottomModelDelegate {
    func sendInfos(_ likeCondition:Bool,_ favoriteCondition:Bool, comment:CommentStruct)
}


class CommentCellBottomModel:NSObject,FireBaseCellDelegate{
  
    var delegate:CommentCellBottomModelDelegate?
    let firebaseService = FirebaseService()
    var favoriteCondition:Bool=false
    var likeCondition:Bool=false
    var comment:CommentStruct?
    var controller:UIViewController?
    
    override init() {
        super.init()
    }
    convenience init(_ controller:UIViewController,comment:CommentStruct) {
        self.init()
        self.controller = controller
        self.comment = comment
        firebaseService.cellDelegate = self
        firebaseTriggered()
       
    }
    
    private func firebaseTriggered(){
         guard let comment = comment else {return} // check comment is not nill
        
//        fetch favorite condition for actual user
         firebaseService.fetchFavoriteCondition(entryID: comment.entryID, commentID: comment.commentID) { (error) in
             if let error = error{
                 print("fetching favorite data error \(error) ")
             }
         }
        
//        add listener because app show snap change
             firebaseService.fetchCommentListener(entryID: comment.entryID, commentID: comment.commentID) { (error) in
                 if let error = error{
                     print("fetching favorite number error \(error) ")
                 }
     }
        
//        fetch favorite condition for actual user like condition
        
     firebaseService.fetchlikeCondition(entryID: comment.entryID, commentID: comment.commentID) {(error) in
         if let error = error{
             print("fetching like number error \(error) ")
         }
         }
    }

    
    func decideToFavoriteImage(_ fill: Bool) {
        self.favoriteCondition = fill
        listener()
    }
    
    func decideToLikeImage(_ fill: Bool) {
        self.likeCondition = fill
        listener()
    }
    
    func listenSingleComment(_comment: CommentStruct) {
        self.comment = _comment
        listener()
    }
    
    func listener(){
        guard  let comment = comment  else {
            return
        }
        delegate?.sendInfos(likeCondition, favoriteCondition, comment: comment)
    }
    
    
    
    
    func shareClicked() {
        guard let comment = comment,let controller = controller else {return}
        let ac = UIActivityViewController(activityItems: [comment.commentText], applicationActivities: nil)
        controller.present(ac, animated: true, completion: nil)
    }
    
    
    func menuClicked() {
        guard let controller = controller else {return}
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
        controller.present(alertView, animated: true, completion: nil)
        
    }
    
   
    
    func likeClicked() {
        
        guard let comment = comment else {return}
        
        firebaseService.addorRemoveFromLike(entryID: comment.entryID, commentID: comment.commentID) { (error) in
           
            if let error = error{
                print(error.localizedDescription)
        }
        }
       
    }
    
    
    
    func favoriteClicked() {
        guard let comment = comment else {return}
        firebaseService.addorRemoveToFavorites(entryID: comment.entryID, commentID: comment.commentID) { (error) in
            if let error = error{
                print(error.localizedDescription)
        }
        }
    }
    
}
