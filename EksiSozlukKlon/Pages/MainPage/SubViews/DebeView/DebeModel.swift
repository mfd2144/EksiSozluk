//
//  DebeModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 14.04.2021.
//

import Foundation


import UIKit
import Firebase

class DebeModel:NSObject{
    
    let firebaseService = FirebaseService()
    var sendEntity:(([EntryStruct])->())?
    var parent:UIViewController? //we chose parent as a view controller, thus we can use some method in parent controller
    
    
    
    override init() {
        super.init()
        firebaseService.fetchEntries(yesterday: true){ (entities, error) in
            if let _ = error{
                print("entity fetching error\(error!.localizedDescription)")
            }else{
                self.sendEntity?(entities)
            }
        }
    }
    
    

    
    func callCommentView(row:Int,entry:EntryStruct){
        let commentNavVC = CommentNavController()
        commentNavVC.modalPresentationStyle = .fullScreen
        commentNavVC.entry = entry
        IdSingleton.shared.entryID = entry.documentID
        parent?.presentToRight(commentNavVC)
        
        
    }
    
    
}
