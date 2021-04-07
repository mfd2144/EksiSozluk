//
//  LogupModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 1.04.2021.
//

import Foundation
import Firebase

class LogupModel:NSObject{
    
    let firebaseService = FirebaseService()
    
    override init() {
        super.init()
    }
    
    func saveNewUser(_ user:UserStruct){
        firebaseService.createUser(userInfo: user)
    }
}
