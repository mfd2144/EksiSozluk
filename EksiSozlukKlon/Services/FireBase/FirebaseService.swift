//
//  FirebaseService.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 1.04.2021.
//

import UIKit
import Firebase

class FirebaseService:NSObject{
     
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    lazy var userCollection = db.collection("User")
    var authStatus :((Status)->())?
    
    
    override init() {
        super.init()
        if user != nil {
            authStatus?(.login)
        }else{
            authStatus?(.logout)
        }
        
    }
 
    
    
    //MARK: -  Add new user and control it via sign in method
    
    func createUser(user:UserStruct){
        Auth.auth().createUser(withEmail: user.email, password: user.password) { authResult, error in
            if let error = error {
                print("Adding new user error\(error)")
            }else{
                let changeRequest = authResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = user.nick
                changeRequest?.commitChanges(completion: { (error) in
                    if let _ = error {
                        print("User couldn't been created \(error!.localizedDescription)")
                    }
                    guard let id = authResult?.user.uid else {return}
                    self.saveNewUsersInfo(user,id)
                })
            }
        }
    }
    
    private func saveNewUsersInfo(_ user: UserStruct,_ id:String){
        userCollection.addDocument(data: ["userNick" : user.nick,
                                          "createDate": user.createDate,
                                          "userBirthday": user.birtday,
                                          "userGender":user.gender,
                                          "userID" : id
        
        
        ]){ error in
            guard let _ = error else {return}
            print("User information couldn't been added \(error!.localizedDescription)")
        }
    }
    
    func userSignIn(_ email:String,_ password:String){
        Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
            if let error = error {
                print(error)
            }else{
                self.authStatus?(.login)
                self.doAfterSingIn()
            }
        }
    }
    
    func doAfterSingIn(){
        print("open a new view control")
    }
    
    
    func logout(){
        do {
            try Auth.auth().signOut()
        }catch{
            print("lout error \(error.localizedDescription)")
            return
        }
        self.authStatus?(.logout)
    }
    
}
