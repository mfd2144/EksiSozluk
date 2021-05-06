//
//  EntityStruct.swift
//  
//
//  Created by Mehmet fatih DOĞAN on 2.04.2021.
//

import Foundation
import Firebase

struct  EntryStruct {
    let entryLabel:[String]
    let date: FieldValue
    let comments:Int
    let userID:String
    let documentID:String
    let category: String
    let followNumber:Int
    
    init(entryLabel:[String],comments:Int,userID:String,category:String) {
        self.comments = comments
        self.userID = userID
        self.entryLabel = entryLabel
        date = FieldValue.serverTimestamp()
        documentID = ""
        self.category = category
        self.followNumber = 0
        
    }
    
    init(querySnapshot:DocumentSnapshot,documentID:String) {
        entryLabel = querySnapshot[entry_text] as? [String] ?? []
        date = querySnapshot[create_date] as? FieldValue   ?? FieldValue.serverTimestamp()
        comments = querySnapshot[comments_number] as? Int ?? 0
        userID = querySnapshot[user_ID] as? String ?? "quest"
        self.documentID = documentID
        self.category = querySnapshot[category_string] as? String ?? "other"
        self.followNumber = querySnapshot[follow_number] as? Int ?? 0
    }
    

   
}

extension EntryStruct:Equatable{
    static func == (lhs:EntryStruct,rhs:EntryStruct)->Bool{
        return lhs.documentID == rhs.documentID
    }
}
