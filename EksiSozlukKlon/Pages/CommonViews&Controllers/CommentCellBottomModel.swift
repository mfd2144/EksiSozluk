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
    
    var situationLogic:Bool = false
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
        firebaseService.checkUserInList(otherUserId: comment.userId) { [self] situation, error in
            if error != nil {
                situationLogic = false
            }else{
                situationLogic = situation
            }
        }
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
        guard let controller = controller,let comment = comment else {return}
        
        let alertView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionSendMessage = UIAlertAction(title: "mesaj gönder", style: .default) { (_) in
            let anotherUser = BasicUserStruct(nick: comment.userNick, userID: comment.userId)
            let sendMessage = SendMessageViewController()
            sendMessage.contactedUser = anotherUser
            controller.navigationController?.pushViewController(sendMessage, animated: true)
        }
        
        let actionFollowUser = UIAlertAction(title: "yazarı takip et", style: .default) { [self] (_) in
            situationLogic = !situationLogic
            firebaseService.addUserToFollowList(otherUserId: comment.userId) { error in
                if let error = error {
                    print("user couldn't add to your list : \(error.localizedDescription)")
                }
            }
            
        }
        
        
        let actionUnfollowUser = UIAlertAction(title: "yazarı takipten çıkar", style: .default) { [self] _ in
            firebaseService.deleteUserFromFollowList(otherUserId: comment.userId) { error in
                if let error = error {
                    print("user couldn't delete to your list : \(error.localizedDescription)")
                }else{
                    situationLogic = !situationLogic
                }
            }
        }
        
        
        
        if firebaseService.user?.uid == comment.userId {
            let deleteAction = UIAlertAction(title: "sil", style: .destructive) { (_) in
                self.deleteComment()
            }
            alertView.addAction(deleteAction)
            
        }
        
        
        
        let actionCancel = UIAlertAction(title: "vazgeç", style: .cancel)
        
        if firebaseService.user?.uid != comment.userId {
            alertView.addAction(actionSendMessage)
            situationLogic ?alertView.addAction(actionUnfollowUser) :alertView.addAction(actionFollowUser)
        }
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
    
    private func deleteComment(){
        
        
        guard let entryId = comment?.entryID,  let commentId = comment?.commentID else{return}
        controller?.navigationController?.popToRootViewController(animated: true)
   
        self.firebaseService.deleteComment(entryId, commentId) { (error) in
            if let error = error {
                print("can't delete comment \(error.localizedDescription)")
            }
        }
    }
}
