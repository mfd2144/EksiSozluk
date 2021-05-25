//
//  RookieModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 16.05.2021.
//

import Foundation


import UIKit
import Firebase

class RookieModel:NSObject{
    
    let firebaseService = FirebaseService()
    var sendEntries:(([EntryStruct])->())?
    var parent:UIViewController? //we chose parent as a view controller, thus we can use some method in parent controller
    
    
    
    override init() {
        super.init()
        firebaseService.fetchRookiesEntries(){ entries,error in
            if let error = error{
                print("rookies' entry loading error : \(error.localizedDescription)")
            }else{
                self.sendEntries?(entries)
            }
            
        }
    
    }
    
    

    
    func callCommentView(row:Int,entry:EntryStruct){
        let commentNavVC = CommentNavController()
        commentNavVC.modalPresentationStyle = .fullScreen
        commentNavVC.entry = entry
        AppSingleton.shared.selectedView = .caylak
        parent?.presentToRight(commentNavVC)
        
        
    }
    
    
}
