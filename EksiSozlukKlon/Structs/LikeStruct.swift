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
    let LikeID:String
    
    init(data:QueryDocumentSnapshot,LikeID:String) {
        userID = data.data()[user_ID] as? String ?? ""
        commentID = data.data()[comment_ID] as? String ?? ""
        self.LikeID = LikeID
    }
    static func createLikeArray(querySnapShot:QuerySnapshot)->[LikeStruct]{
        var Likes = [LikeStruct]()
        for doc in querySnapShot.documents{
            let id = doc.documentID
            Likes.append(LikeStruct.init(data: doc, LikeID: id))
        }
        return Likes
    }
}
