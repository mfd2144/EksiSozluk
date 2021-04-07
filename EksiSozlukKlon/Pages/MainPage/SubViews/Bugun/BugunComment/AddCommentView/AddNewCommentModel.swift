//
//  AddNewCommentModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 6.04.2021.
//

import UIKit




class AddNewCommentModel :NSObject{
let firebaseService = FirebaseService()
    override init() {
        super.init()
    }
    func addNewComment(text:String){
        guard let id = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.id else {return}
        firebaseService.addNewComment(id, comment: text)
    }
    
}
