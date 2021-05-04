//
//  MessageCell.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 19.04.2021.
//

import UIKit
import Firebase

class MessageCell:UITableViewCell{
    
    let firebaseService = FirebaseService()
    
    var chat:Chat?{
        didSet{
            setCell()
        }
    }
    
   private let avatarPhoto:UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.circle"))
        image.tintColor = .systemGray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    private let userName:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .black)
        label.text = "mfd"
        return label
    }()
    
    private let messageLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "mfd sana birmesaj gönderdi.açarmısın şu mesajı arkadaşım"
        return label
    }()
    
    private let labelStackView: UIStackView  = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.text = "12.04.2021"
        return label
    }()
    
    
    private  let trailingStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .trailing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = .systemBackground
        setView()    
    }
    
    
    private func setView(){
        labelStackView.addArrangedSubview(userName)
        labelStackView.addArrangedSubview(messageLabel)
        trailingStack.addArrangedSubview(dateLabel)
        addSubview(avatarPhoto)
        addSubview(trailingStack)
        addSubview(labelStackView)
        
        
        NSLayoutConstraint.activate([avatarPhoto.heightAnchor.constraint(equalToConstant: 60),
                                     avatarPhoto.widthAnchor.constraint(equalToConstant: 60),
                                     avatarPhoto.topAnchor.constraint(equalTo: topAnchor,constant: 5),
                                     avatarPhoto.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5),
                                     avatarPhoto.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 20),
                                     avatarPhoto.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     trailingStack.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20),
                                     trailingStack.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     labelStackView.leadingAnchor.constraint(equalTo: avatarPhoto.trailingAnchor, constant: 20),
                                     labelStackView.leadingAnchor.constraint(equalTo: avatarPhoto.trailingAnchor, constant: 20),
                                     labelStackView.trailingAnchor.constraint(equalTo: trailingStack.leadingAnchor, constant: -20),
                                     labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    func setCell(){
        guard let chat = chat else {return}
        var otherUserName:String?
        var firstMessage:String?
        chat.usersNick.forEach { name in
            if name != Auth.auth().currentUser?.displayName{
                otherUserName = name
            }
            
        }
        chat.owners.forEach({ 
          if  $0["owner"] as? String == Auth.auth().currentUser?.uid{
                firstMessage = $0[first_message] as? String
            }
        })
        
        userName.text = otherUserName
        messageLabel.text = firstMessage
        let date = chat.date.dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        dateLabel.text = formatter.string(from: date)
    }
    

}
