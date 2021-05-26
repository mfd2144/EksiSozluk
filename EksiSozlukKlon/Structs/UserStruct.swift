//
//  UserStruct.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 1.04.2021.
//

import Foundation
import Firebase



struct  UserStruct{
    let email:String
    let password:String?
    let gender:Int
    let nick:String
    let birtday: Date?
    let createDate: Timestamp
    let totalEntry :Int
    let totalContact: Int
  
    
    init(email:String,nick:String,password:String?,gender:Int,birthday:Date?) {
        self.createDate = Timestamp.init(date: Date())
        self.email = email
        self.nick = nick
        self.password = password
        self.gender = gender
        self.birtday = birthday
        self.totalEntry = 0
        self.totalContact = 0
    }
    
    
    init?(_ data:[String:Any]){
    
       guard let email = data[user_email] as? String,
             let nick = data[user_nick] as? String,
             let gender = data[user_gender] as? Int,
             let createDate = data[create_date] as? Timestamp,
             let totalEntry = data[user_total_entity]  as? Int,
             let totalContact = data[user_total_contact] as? Int
       else { return nil}
        
        if let timeStamp = data[user_birthday] as? Timestamp {
            self.birtday = Timestamp.dateValue(timeStamp)()
        }else{
            self.birtday = nil
        }
       
        self.createDate = createDate
        self.email = email
        self.nick = nick
        self.password = nil
        self.totalEntry = totalEntry
        self.totalContact = totalContact
        self.gender = gender
    
    }
    
   
    
}

