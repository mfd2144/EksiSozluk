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
    var docRef:DocumentReference?
    var usersNick: [String]
    var date:Timestamp
    var chatID:String? = nil
    var owners:[[String:Any]]
    var newMessages : [String:Int]
    
    // use this dictionary as ["userID string":unread number ]
    //if unread number more than 0 tabbar badge will  show it
    
    var dictionary: [String: Any] {
        return [
            users_ID : users,
            users_nick:usersNick,
            create_date:date,
            "owners":owners,
            new_messages:newMessages
        ]
    }
    
}

extension Chat {
    
    init?(dictionary: [String:Any],ref:DocumentReference,id:String) {
        guard let chatUsers = dictionary[users_ID] as? [String],
            let nicks = dictionary[users_nick] as? [String],
              let createDate = dictionary[create_date] as? Timestamp,
              let  owners = dictionary["owners"] as? [[String: Any]],
              let newMessages = dictionary[new_messages] as? [String: Int]
              else {return nil}
        
        self.init(users: chatUsers, docRef: ref,usersNick:nicks,date:createDate,chatID:id, owners: owners, newMessages: newMessages )
    }
    
}
