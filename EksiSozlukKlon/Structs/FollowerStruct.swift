//
//  FollowerStruct.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 14.04.2021.
//

import Foundation
import Firebase

struct  FollowerStruct {
    let userID:String
    let  entryID:String
    let followID:String
    
    init(data:QueryDocumentSnapshot,followID:String) {
        userID = data.data()[user_ID] as? String ?? ""
        entryID = data.data()[entry_ID] as? String ?? ""
        self.followID = followID
    }
    
    
    static func createFavoriteArray(querySnapShot:QuerySnapshot)->[FollowerStruct]{
        var followers = [FollowerStruct]()
        for doc in querySnapShot.documents{
            let id = doc.documentID
            followers.append(FollowerStruct.init(data: doc, followID: id))
        }
        return followers
    }
}
