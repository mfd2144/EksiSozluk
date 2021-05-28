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
    weak var alertView:MutualAlertViewController!
    var parentView:UIViewController?
    
    override init() {
        super.init()
    }
    
    func saveNewUser(_ user:UserStruct){
        firebaseService.createUser(userInfo: user){ message,error  in
            if let error = error{
                print(error)
            }
            self.alertView = MutualAlertViewController(message: message, self.parentView!)
            
        }
    }
    
    func userLogin(_ credential:AuthCredential){
        firebaseService.credentialLogin(credential)
        print(" logup model userLogin çalıştı")
    }
}
