//
//  LogupView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 1.04.2021.
//

import UIKit
import GoogleSignIn

class LogupViewController:UIViewController{
    let viewModel = LogupViewModel()
    let model = LogupModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
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
    func logupButtonClicked(_ user: UserStruct) {
        model.saveNewUser(user)
    }
    func googleSignInPressed() {
        GIDSignIn.sharedInstance().signIn()
    }
    
}
