//
//  CommentViewModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 5.04.2021.
//

import UIKit

class CommentsTableModel: NSObject {
    
    var comments:(([CommentStruct])->())?
    let firebaseService = FirebaseService()

    override init() {
        super.init()
    }
    
    func fetchComments(documentID:String?){
        guard let id = documentID else {return}
        firebaseService.fetchComments(documentID:id) { [self] (_comments, error) in
            if let _ = error {
                print("Fetching comments error \(error!.localizedDescription)")
            }else{
                comments?(_comments)
            }
        }
        
    }
    
    func newAlert()->UIAlertController{
        
        let alertView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionFollowed = UIAlertAction(title: "takip ettiklerim", style: .default) { (actionSendMes) in
            print("takip ettiklerim")
        }
        let actionMyComment = UIAlertAction(title: "benimkiler", style: .default) { (actionBlock) in
            print("benimkiler")
        }
                let actionCancel = UIAlertAction(title: "vazgeç", style: .cancel)
        alertView.addAction(actionFollowed)
        alertView.addAction(actionMyComment)
        alertView.addAction(actionCancel)
        
        return alertView
    }
    
    func searchKeyWord(_ documentID:String?, _ keyWord: String){
        guard let id = documentID else {return}
        firebaseService.fetchComments(documentID: id, keyWord: keyWord) { [self] (_comments, error) in
            if let _ = error {
                print("Fetching comments error \(error!.localizedDescription)")
            }else{
                comments?(_comments)
            }
    }

}
    
    
    
    
}
