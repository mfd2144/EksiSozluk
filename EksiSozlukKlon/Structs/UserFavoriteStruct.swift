//
//  UserFavoriteStruct.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 15.04.2021.
//

import Foundation
import Firebase

struct  UserFavoriteStruct {
    let  commentID:String
    let entryID:String
    
    
    init(_ queryDocumentSnapShot:QueryDocumentSnapshot) {
        
        let doc = queryDocumentSnapShot.data()
        commentID = doc[comment_ID] as? String ?? ""
        entryID = doc[entry_ID] as?  String ?? ""
        
        
    }
    
}
