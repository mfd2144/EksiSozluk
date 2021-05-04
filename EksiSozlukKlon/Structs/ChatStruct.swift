//
//  ChatStruct.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.04.2021.
//

import Foundation
import UIKit
import Firebase

struct Chat {
    
    var users: [String]
//    var firstMessage:String
    var docRef:DocumentReference?
    var usersNick: [String]
    var date:Timestamp
    var chatID:String? = nil
    var owners:[[String:Any]]
    var dictionary: [String: Any] {
        return [
            users_ID : users,
//            first_message:firstMessage,
            users_nick:usersNick,
            create_date:date,
            "owners":owners
        ]
    }
    
}

extension Chat {
    
    init?(dictionary: [String:Any],ref:DocumentReference,id:String) {
        guard let chatUsers = dictionary[users_ID] as? [String],
            let nicks = dictionary[users_nick] as? [String],
//              let firstMsg = dictionary[first_message] as? String,
              let createDate = dictionary[create_date] as? Timestamp,
              let  owners = dictionary["owners"] as? [[String: Any]]
              else {return nil}
        
        self.init(users: chatUsers, docRef: ref,usersNick:nicks,date:createDate,chatID:id, owners: owners)
    }
    
}
