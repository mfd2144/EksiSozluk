//
//  CommentNavigationMenuView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 4.04.2021.
//

import UIKit


class CommentNavMenuView:CommentNavTopComponent{
    
    let buttonFirst:UIButton = {
        let button = UIButton()
        button.setTitle("ilk", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    let buttonLast:UIButton = {
        let button = UIButton()
        button.setTitle("son", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 3
        button.frame.size = CGSize(width: 40, height: 20)
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    
    let buttonPrevious:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 3
        button.frame.size = CGSize(width: 40, height: 20)
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    let buttonNext:UIButton={
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 3
        button.frame.size = CGSize(width: 40, height: 20)
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    
    let arrowButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 3
        button.frame.size = CGSize(width: 40, height: 20)
       
        return button
    }()
    
    let labelPangeNumber :UILabel = {
        let label = UILabel()
        label.text = "1/1"
        label.backgroundColor = .systemGray6
        label.frame.size = CGSize(width: 80, height: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    let middleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 0
        return stack
    }()
    
    let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func otherSettings() {
        middleStack.addArrangedSubview(labelPangeNumber)
        middleStack.addArrangedSubview(arrowButton)
        mainStack.addArrangedSubview(buttonFirst)
        mainStack.addArrangedSubview(buttonPrevious)
        mainStack.addArrangedSubview(middleStack)
        mainStack.addArrangedSubview(buttonNext)
        mainStack.addArrangedSubview(buttonLast)
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topComponentStack.bottomAnchor),
            mainStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStack.heightAnchor.constraint(equalToConstant: 40),
            buttonFirst.heightAnchor.constraint(equalToConstant: 25),
            buttonFirst.widthAnchor.constraint(equalToConstant: 50),
            
            buttonLast.heightAnchor.constraint(equalToConstant: 25),
            buttonLast.widthAnchor.constraint(equalToConstant: 50),
            
            
            buttonPrevious.heightAnchor.constraint(equalToConstant: 25),
            buttonPrevious.widthAnchor.constraint(equalToConstant: 50),
            
            
            buttonNext.heightAnchor.constraint(equalToConstant: 25),
            buttonNext.widthAnchor.constraint(equalToConstant: 50),
            
            
            labelPangeNumber.heightAnchor.constraint(equalToConstant: 25),
            labelPangeNumber.widthAnchor.constraint(equalToConstant: 40),
    
        ])
        
    }
    
}

