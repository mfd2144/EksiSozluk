//
//  MutualViewController.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 30.03.2021.
//

import UIKit


class MutualUnregisterViewController: UIViewController {

    
    private let eksiStack :EksiStack = {
      let stack = EksiStack()
        return stack
    }()
    
    
    let labelCenterMain:UILabel={
       let label = UILabel()
        label.text = "something here"
        label.font = UIFont.systemFont(ofSize: 25, weight: .light)
        label.textAlignment = .center
        return label
    }()
    let labelCenterSmall:UILabel={
       let label = UILabel()
        label.text = "explaining this thing in here"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    let imageCenter :UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage.init(systemName: "bell")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let stackCenter:UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    
    private let stackBottom:UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 5
        return stack
    }()
    
    private lazy var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("giriş yap", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        button.addTarget(self, action: #selector(loginButtonPushed), for: .touchUpInside)
        return button
    }()
    private let labelBottom:UILabel={
       let label = UILabel()
        label.text = "hesabın var mı?"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private lazy var logupButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("kayıt ol", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.systemBackground, for: .normal)
        button.addTarget(self, action: #selector(logupButtonPushed), for: .touchUpInside)
        button.layer.cornerRadius = 25
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setStackView()
        addButton()
        setCenterStack()
        addBottomStack()
  
      
    }
    
    private func setStackView(){

        
        view.addSubview(eksiStack)
        
        NSLayoutConstraint.activate([
           
            eksiStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eksiStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 50)
        ])
     
    }
    private func addButton(){
        view.addSubview(logupButton)
        NSLayoutConstraint.activate([
            logupButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            logupButton.heightAnchor.constraint(equalToConstant: 50),
            logupButton.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            logupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -80)
            
        ])
        
    }
    

    @objc private func logupButtonPushed(_ sender:UIButton){
        logupClicked()
    }
    @objc private func loginButtonPushed(_ sender:UIButton){
        loginClicked()
    }

  
    private func  setCenterStack(){
        stackCenter.addArrangedSubview(imageCenter)
        stackCenter.addArrangedSubview(labelCenterMain)
        stackCenter.addArrangedSubview(labelCenterSmall)
        view.addSubview(stackCenter)
        
        NSLayoutConstraint.activate([
            stackCenter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackCenter.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -100),
            imageCenter.heightAnchor.constraint(equalToConstant: 100),
        ])
        
    }
    
   private func addBottomStack(){
    stackBottom.addArrangedSubview(labelBottom)
    stackBottom.addArrangedSubview(loginButton)
    view.addSubview(stackBottom)
    NSLayoutConstraint.activate([
        stackBottom.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        stackBottom.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20),
        
    ])
    
    }
    
    
    func logupClicked(){
        present(LogupViewController(), animated: true, completion: nil)
    }
    
    func loginClicked(){
        present(LoginViewController(), animated: true, completion: nil)
    }
  
   
}
