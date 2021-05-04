//
//  LoginViewModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 31.03.2021.
//

import UIKit


class LoginViewModel:MutualLogView{

    
   
    var controller:((UIViewController)->())?
    var parentController:UIViewController?
    var delegate : LoginViewModelDelegate?
    
    let textStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 0
        return stack
    }()
    
    let userEmailCautionLabel:UILabel = {
        let label = UILabel()
        label.text = "böyle e-mail olmaz olsun"
        label.textAlignment = .left
        
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemBackground
        return label
    }()
    let userEmailField :UITextField = {
        let field = UITextField()
        field.text = "e-mail"
        field.keyboardType = .emailAddress
        field.textContentType = .emailAddress
        field.layer.borderWidth = 0
        return field
    }()
    let passwordCautionLabel:UILabel = {
        let label = UILabel()
        label.text = "şifreniz gerekli"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemBackground
        return label
    }()
    let line1Field:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
        
    }()
  
    let line2Field:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
        
    }()
    
    let passwordField :UITextField = {
        let field = UITextField()
        field.text = "şifreniz"
    
        field.layer.borderWidth = 0

        return field
    }()
    
    lazy var loginButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemGreen
        button.setTitle("bağlan", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBackground
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var logoutButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemGreen
        button.setTitle("çık silinecek", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBackground
        button.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton:UIButton = {
        let button = UIButton()
       
        button.backgroundColor = .systemGray3
        button.setTitle("vazgeç", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBackground
        button.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        passwordField.delegate = self
        userEmailField.delegate = self
        setTextStack()
        setLoginButton()
        setLogoutButton()
        setCancelButton()
        controller = { controller in
            self.parentController = controller
            
        }
        
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setTextStack(){
      
        textStack.addArrangedSubview(userEmailCautionLabel)
        textStack.addArrangedSubview(userEmailField)
        textStack.addArrangedSubview(line1Field)
        textStack.addArrangedSubview(passwordCautionLabel)
        textStack.addArrangedSubview(passwordField)
        textStack.addArrangedSubview(line2Field)
                addSubview(textStack)
        
        
        NSLayoutConstraint.activate([
                                        textStack.widthAnchor.constraint(equalTo:widthAnchor),
            textStack.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 100),
        line1Field.heightAnchor.constraint(equalToConstant: 2),
        line2Field.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    
    
   private func setLoginButton(){
    addSubview(loginButton)
    
    NSLayoutConstraint.activate([
        loginButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
        loginButton.heightAnchor.constraint(equalTo: faceButton.heightAnchor),
        loginButton.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 50),
        loginButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        
    ])
    }
    
    private func setLogoutButton(){
     addSubview(logoutButton)
     
     NSLayoutConstraint.activate([
         logoutButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
         logoutButton.heightAnchor.constraint(equalTo: faceButton.heightAnchor),
         logoutButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 50),
         logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor)
         
     ])
     }
    
    
    
    private func setCancelButton(){
     addSubview(cancelButton)
     
     NSLayoutConstraint.activate([
         cancelButton.widthAnchor.constraint(equalTo: widthAnchor),
        cancelButton.heightAnchor.constraint(equalToConstant: 60),
         cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor),
         cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor)
         
     ])
     }
    
    
    override func googlePressed() {
        delegate?.googleSignInPressed()
    }
    
}

extension LoginViewModel:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
   @objc private func cancelPressed(){
    parentController?.dismiss(animated: true, completion: nil)

    }
    
    @objc func loginButtonPressed(){
        delegate?.loginButonClicked()
    }
    @objc func logoutButtonPressed(){
        delegate?.eraseFormandDissmissed()
    }
    

    
 
}


protocol LoginViewModelDelegate {
    func loginButonClicked()
    func eraseFormandDissmissed()
    func googleSignInPressed()
}
