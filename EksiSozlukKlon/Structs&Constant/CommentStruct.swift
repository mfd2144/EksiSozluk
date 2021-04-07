//
//  CommentStruct.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 2.04.2021.
//

import Foundation
import Firebase


struct CommentStruct{
    let commentText:String
    let userNick:String
    let userId:String
    let createDate:Date
    let likes:Int
    let favories:Int
    let commentID:String
    let entryID:String
    
    
    init(snapShot:DocumentSnapshot,commentID:String){
        self.commentText = snapShot[comment_text] as! String
        self.userNick = snapShot[user_nick] as! String
        self.userId = snapShot[user_ID] as! String
        self.likes = snapShot[likes_number] as! Int
        self.favories = snapShot[favorites_number] as! Int
        let date = snapShot[create_date] as! Timestamp
        self.createDate = date.dateValue()
        self.entryID = snapShot[entry_ID] as! String
        self.commentID = commentID
    }
}

