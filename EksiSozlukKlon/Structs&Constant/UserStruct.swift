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
    let password:String
    let gender:Int
    let nick:String
    let birtday: Date
    let createDate: FieldValue
    
    init(email:String,nick:String,password:String,gender:Int,birthday:Date) {
        self.createDate = FieldValue.serverTimestamp()
        self.email = email
        self.nick = nick
        self.password = password
        self.gender = gender
        self.birtday = birthday
    }
}
