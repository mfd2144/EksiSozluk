//
//  BasicUserStruct.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 21.04.2021.
//

import Foundation
import Firebase

struct BasicUserStruct {
    let nick:String
    let userId:String

    init(nick:String,userID:String){
        self.nick = nick
        self.userId = userID
    }
    init(query:QueryDocumentSnapshot) {
        nick = query[user_nick] as? String ?? ""
        userId = query[user_ID] as? String ?? ""
    }
    
    static func getUsersForSeach(_ querySnapshot:QuerySnapshot?)->[BasicUserStruct]{
        var users = [BasicUserStruct]()
        guard let docs = querySnapshot?.documents else{ return users }
        for doc in docs{
            users.append(BasicUserStruct.init(query: doc))
        }
        return users
        
        
    }
}
