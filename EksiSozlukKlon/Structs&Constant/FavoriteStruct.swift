//
//  FavoriteStruct.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 7.04.2021.
//

import Foundation
import Firebase

struct  FavoriteStruct {
    let userID:String
    let  commentID:String
    let favoriteID:String
    
    init(data:QueryDocumentSnapshot,favoriteID:String) {
        userID = data.data()[user_ID] as? String ?? ""
        commentID = data.data()[comment_ID] as? String ?? ""
        self.favoriteID = favoriteID
    }
    static func createFAvoriteArray(querySnapShot:QuerySnapshot)->[FavoriteStruct]{
        var favorites = [FavoriteStruct]()
        for doc in querySnapShot.documents{
            let id = doc.documentID
            favorites.append(FavoriteStruct.init(data: doc, favoriteID: id))
        }
        return favorites
    }
}
