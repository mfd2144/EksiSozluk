//
//  LoginViewController.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 31.03.2021.
//

import UIKit

class LoginViewController: UIViewController {
  

    let model = LoginModel()
    let viewModel = LoginViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.controller?(self)
        setViewModel()
        viewModel.delegate = self
        let bounds = UIScreen.main.bounds
        viewModel.scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height*CGFloat(1.2))
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
    func loginButonClicked() {
        guard let email = viewModel.userEmailField.text, let password = viewModel.passwordField.text else { return }
        model.userLogin(email , password)
    }
    func logoutButonClicked() {
        model.userLogout()
    }
}