//
//  File.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 7.04.2021.
//

import Foundation
import Firebase

struct  LikeStruct {
    let userID:String
    let  commentID:String
    let likeID:String
    
    init(data:QueryDocumentSnapshot,likeID:String) {
        userID = data.data()[user_ID] as? String ?? ""
        commentID = data.data()[comment_ID] as? String ?? ""
        self.likeID = likeID
    }
    init(userID:String,commentID:String,likeID:String){
        self.userID = userID
        self.commentID = commentID
        self.likeID = likeID
    }
    
    static func createLikeArray(querySnapShot:QuerySnapshot)->[LikeStruct]{
        var likes = [LikeStruct]()
        for doc in querySnapShot.documents{
            let id = doc.documentID
            likes.append(LikeStruct.init(data: doc, likeID: id))
        }
        return likes
    }
}
