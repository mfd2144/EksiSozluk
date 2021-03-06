//
//  LogMutualView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 31.03.2021.
//
import UIKit

class MutualLogView:UIView{
    

    
    let scrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .systemBackground
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height )
        return scroll
    }()
    
    
    private let eksiStack:EksiStack = {
        let eksi = EksiStack()
        eksi.translatesAutoresizingMaskIntoConstraints = false
        
        return eksi
    }()
    
    let buttonStack:UIStackView={
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        return stack
    }()
    
    let faceButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemBlue
        let imageView = UIImageView(image: UIImage(named:"face"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 15),  imageView.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.8),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        button.setTitle("facebook ile bağlan", for: .normal)
        button.tintColor = .systemBackground
        return button
    }()
    
    let googleButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .lightGray
        button.setTitle("google ile bağlan", for: .normal)
        let imageView = UIImageView(image: UIImage(named:"google"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        button.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 15),
            imageView.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.8),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        button.tintColor = .systemBackground
        return button
    }()
    
    private let buttonStackLabel:UILabel = {
        let label = UILabel()
        label.text = "ya da"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        setScrollView()
        setEksiStack()
        setButtonStack()
        setTargets()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setScrollView(){
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
                                        scrollView.topAnchor.constraint(equalTo: topAnchor) ,
                                        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor) ,
                                        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor) ,
                                        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor) ])
        
        
    }
    private func setEksiStack(){
        scrollView.addSubview(eksiStack)
        
        NSLayoutConstraint.activate([
            eksiStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            eksiStack.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 50)
        ])
        
    }
    private func setButtonStack(){
        buttonStack.addArrangedSubview(faceButton)
        buttonStack .addArrangedSubview(googleButton)
        buttonStack.addArrangedSubview(buttonStackLabel)
        
        
        scrollView.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            buttonStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor,multiplier: 0.6),
            buttonStack.topAnchor.constraint(equalTo: eksiStack.bottomAnchor,constant: 50),
            buttonStack.heightAnchor.constraint(equalToConstant: 140)
            
        ])
    }
    private func setTargets(){
        googleButton.addTarget(self, action: #selector(googleButtonPressed(_ :)), for: .touchUpInside)
        faceButton.addTarget(self, action: #selector(faceButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc private func googleButtonPressed(_ sender:UIButton){
     googlePressed()
    }
    
    func googlePressed(){
        
    }
 
    @objc private func faceButtonPressed(_ sender:UIButton){
     facePressed()
    }
    
    func facePressed(){
        
    }
}

