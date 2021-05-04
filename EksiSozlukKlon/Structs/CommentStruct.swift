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
        self.commentText = snapShot[comment_text] as? String ?? ""
        self.userNick = snapShot[user_nick] as? String ?? ""
        self.userId = snapShot[user_ID] as? String ?? ""
        self.likes = snapShot[likes_number] as? Int ?? 0
        self.favories = snapShot[favorites_number] as? Int ?? 0
        let date = snapShot[create_date] as? Timestamp
        self.createDate = date?.dateValue() ?? Date()
        self.entryID = snapShot[entry_ID] as? String ?? ""
        self.commentID = commentID
    }
}


extension CommentStruct:Equatable{
    static func == (lhs:CommentStruct,rhs:CommentStruct)->Bool{
        return lhs.commentID == rhs.commentID
    }
}
