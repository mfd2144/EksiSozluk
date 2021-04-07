//
//  EntityStruct.swift
//  
//
//  Created by Mehmet fatih DOĞAN on 2.04.2021.
//

import Foundation
import Firebase

struct  EntryStruct {
    let entryLabel:String
    let date: FieldValue
    let comments:Int
    let userID:String
    let documentID:String

    
    init(entryLabel:String,comments:Int,userID:String) {
        self.comments = comments
        self.userID = userID
        self.entryLabel = entryLabel
        date = FieldValue.serverTimestamp()
        documentID = ""
    }
    
    init(querySnapshot:DocumentSnapshot,documentID:String) {
        entryLabel = querySnapshot[entry_text] as? String ?? "boş"
        date = querySnapshot[create_date] as? FieldValue   ?? FieldValue.serverTimestamp()
        comments = querySnapshot[comments_number] as? Int ?? 0
        userID = querySnapshot[user_ID] as? String ?? "misafir"
        self.documentID = documentID
    }
}
