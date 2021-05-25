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
        firebaseService.createUser(userInfo: user){ message,error  in
            if let error = error{
                print(error)
            }
            
        }
    }
    
    func userLogin(_ credential:AuthCredential){
        firebaseService.credentialLogin(credential)
        print(" logup model userLogin çalıştı")
    }
}
