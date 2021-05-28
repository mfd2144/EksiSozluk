//
//  LoginViewController.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 31.03.2021.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAuth


class LoginViewController: UIViewController {

  
    
    let model = LoginModel()
    let viewModel = LoginViewModel()
    let fbManager = LoginManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.controller?(self)
        setViewModel()
        viewModel.delegate = self
        let bounds = UIScreen.main.bounds
        viewModel.scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height*CGFloat(1.2))
 }
    
    override func viewDidLoad() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
    
    }
    
    func setViewModel(){
        view.addSubview(viewModel)
        NSLayoutConstraint.activate([
                          viewModel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                        viewModel.topAnchor.constraint(equalTo: view.topAnchor),
                                        viewModel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                        viewModel.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
    }
    
    

    }
    





extension LoginViewController:LoginViewModelDelegate{
    func facebookSignInPressed() {
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
    
    
    func resetPassword(_ email: String) {
        let cV = CautionView(frame: self.view.bounds)
        cV.cautionText = "şifre değiştirme isteği gönderildi"
        self.view.addSubview(cV)
        
    }
    
    

    
    
    
    func loginButonClicked() {
        guard let email = viewModel.userEmailField.text, let password = viewModel.passwordField.text else { return }
        model.userLogin(email , password)
    }

    func googleSignInPressed() {
        GIDSignIn.sharedInstance().signIn()
    }
}







