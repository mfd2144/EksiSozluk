//
//  CommentNavMenuTopComponent.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 5.04.2021.
//

import UIKit

class CommentNavTopComponent:UIView{
    
    let label:UILabel = {
        let label = UILabel()
        label.text = "bugün"
        label.textAlignment = .left
        return label
    }()
    let topComponentStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .systemGray6
        stack.alignment = .center
        return stack
    }()
    lazy var searchButton:UIButton = {
      let button = setButton("magnifyingglass")
        return button
    }()
    
    lazy var shareButton:UIButton = {
        let button = setButton("square.and.arrow.up")
          return button
    }()
    
    lazy var addFavoriteButton:UIButton = {
        let button = setButton("bell")
          return button
    }()
    
    lazy var sukelaButton:UIButton = {
        let button = setButton("slider.vertical.3")
          return button
     }()
    
    lazy var searcInCommnetButton:UIButton = {
        let button = setButton("heart")
          return button
     }()

    lazy var imageStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sukelaButton,searcInCommnetButton,addFavoriteButton,shareButton,searchButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .trailing
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setStacks()
        otherSettings()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setStacks(){
        topComponentStack.addArrangedSubview(label)
        topComponentStack.addArrangedSubview(imageStack)
        addSubview(topComponentStack)
        
        NSLayoutConstraint.activate([
            topComponentStack.topAnchor.constraint(equalTo: topAnchor),
            topComponentStack.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.96),
            topComponentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            topComponentStack.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
    func setButton(_ imageName:String)->UIButton{
        let button = UIButton()
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = .systemGray3
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        button.heightAnchor.constraint(equalToConstant: 30),
                                        button.widthAnchor.constraint(equalToConstant: 30)])
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.cornerRadius = 15
        button.backgroundColor = .systemBackground
        return button
    }
    func otherSettings(){
        
    }
}
