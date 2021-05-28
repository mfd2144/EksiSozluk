//
//  ChangeUserInformationModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 26.05.2021.
//

import UIKit


class ChangeUserInformationModel: NSObject {
    
    let firebaseService = FirebaseService()
    var userContanier:((UserStruct)->())?
        
    override init() {
        super.init()
        fetchUserInfos()
    }
    
    func fetchUserInfos(){
        firebaseService.fetchUserInformation { user, error in
            if let error = error{
                print("fetching user information error \(error.localizedDescription)")
                
            }else{
                guard let user = user else{ return }
                self.userContanier?(user)
            }
        }
    }
    
    func saveChanges(_ nick:String,_ date:Date,_ gender:Int){
        firebaseService.updateUserInformation(nick: nick, userBirtday: date, gender: gender, email: nil) { error in
            if let error = error {
                print("changes didn't commited \(error.localizedDescription)")
            }else{
                self.fetchUserInfos()
            }
        }
    }
    
    func newTextField()->UITextField{
        let field = UITextField()
        field.backgroundColor = .systemGray6
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 18)
        field.textColor = .none
        field.text = "user name"
        field.layer.cornerRadius = 10
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftView = paddingView
        field.leftViewMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }
    
    func newButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 50
        button.setTitleColor(.none, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
}
