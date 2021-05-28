//
//  LogupView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 1.04.2021.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAuth

class LogupViewController:UIViewController{
    let viewModel = LogupViewModel()
    let model = LogupModel()
    let fbManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        model.parentView = self
        viewModel.delegate = self
        viewModel.controller?(self)
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    
    func setViewModel(){
        view.addSubview(viewModel)
        NSLayoutConstraint.activate([
                                        viewModel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                        viewModel.topAnchor.constraint(equalTo: view.topAnchor),
                                        viewModel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                        viewModel.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        
        
        let bounds = UIScreen.main.bounds
        viewModel.scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height*CGFloat(1.5))
        
    }
    
    
}
extension LogupViewController:LogupViewModelDelegate{
    func faceSignInPressed() {
        fbManager.logIn(permissions: ["email"], from: self) { result, error in
            if let error = error{
                print("print error \(error)")
            }else if result?.isCancelled == true{
              print("cancel")
            }else{
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                self.model.firebaseService.credentialLogin(credential)
                    
                
            }
        }
    }
    
    func logupButtonClicked(_ user: UserStruct) {
        model.saveNewUser(user)
    }
    func googleSignInPressed() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
}
