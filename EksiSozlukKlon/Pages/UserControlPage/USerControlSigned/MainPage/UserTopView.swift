//
//  UserTopView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 11.05.2021.
//

import UIKit

class UserTopView:UIView{
    
    let avatarPhoto:UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.circle"))
        image.tintColor = .systemGray
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    
    
    let userName: UILabel = {
        let label = UILabel()
        label.text = "user name"
        return label
    }()
    
    let userLevel: UILabel = {
        let label = UILabel()
        label.text = "acemi"
        label.textColor = .systemGreen
        return label
    }()
    
    let userInformation: UILabel = {
        let label = UILabel()
        label.text = "heniz 10 entry'yi tamamlanmadığınızdan onay sırasında değilsiniz "
        label.numberOfLines = 0
        return label
    }()
    
    
    
    
    let totalEntry: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    let entryLabel: UILabel = {
        let label = UILabel()
        label.text = "entry"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    lazy var entryStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [totalEntry,entryLabel])
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.axis = .vertical
        return stack
    }()
    
    let totalFollow: UILabel = {
        let label = UILabel()
        label.text = "0"
        return label
    }()
    let followLabel: UILabel = {
        let label = UILabel()
        label.text = "takibinde"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    lazy var followStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [totalFollow,followLabel])
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.axis = .vertical
        return stack
    }()
    
    
    lazy var bottomStack :UIStackView = {
        let stack = UIStackView(arrangedSubviews: [entryStack, followStack])
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var labelStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userName,userLevel,userInformation,bottomStack])
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        stack.axis = .vertical
        return stack
    }()
    
    lazy var mainStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarPhoto,labelStack])
        stack.alignment = .fill
        
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:\(coder) has not been implemented")
    }
    
    private func addViews(){
        addSubview(mainStack)
        NSLayoutConstraint.activate([
            avatarPhoto.widthAnchor.constraint(equalToConstant: 100 ),
            mainStack.widthAnchor.constraint(equalTo: widthAnchor),
            mainStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            mainStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
}


