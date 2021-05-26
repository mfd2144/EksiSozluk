//
//  FollowedUser.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 17.05.2021.
//

import Foundation
import Firebase

struct FollowedUser{
    let userID:String
    let createDate:Timestamp
    
    init?(_ snapShot:DocumentSnapshot){
        userID = snapShot.data()?[followed_user_id] as? String ?? ""
        createDate = snapShot.data()?[followed_date] as? Timestamp ?? Timestamp.init(date: Date())
}
}
