//
//  LoginModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 1.04.2021.
//

import Foundation
import Firebase

class LoginModel:NSObject{
    
    let firebaseService = FirebaseService()
    
    override init() {
        super.init()
    }
    
    func userLogin(_ email:String,_ password:String){
        firebaseService.userSignIn(email, password)
    }

    
    func userLogin(_ credential:AuthCredential){
        firebaseService.credentialLogin(credential)
    }
    
    
    
}
    
    

