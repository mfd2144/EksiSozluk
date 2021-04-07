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
    
    func fetchComments(documentID:String){
       
        firebaseService.fetchComments(documentID:documentID) { [self] (_comments, error) in
            if let _ = error {
                print("Fetching comments error \(error!.localizedDescription)")
            }else{
                comments?(_comments)
            }
        }
        
    }
    
   
}
