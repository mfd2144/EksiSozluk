//
//  SingleCommentBottom.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 6.04.2021.
//

import UIKit

class SingleCommentBottom: UITableViewCell {
    
    var comment:CommentStruct?
    
    let buttonFace:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "face"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonTwitter:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "twitter"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return button
    }()
    
    let buttonWhatsapp:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "whatsapp"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return button
    }()
    let buttonTelegram:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "telegram"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return button
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
    
    
    let buttonStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        buttonWhatsapp.addTarget(self, action: #selector(whatsAppButtonClicked), for: .touchUpInside)
        buttonTwitter.addTarget(self, action: #selector(twitterButtonClicked), for: .touchUpInside)
        buttonTelegram.addTarget(self, action: #selector(telegramclicked), for: .touchUpInside)
        buttonFace.addTarget(self, action: #selector(facebookClicked), for: .touchUpInside)
        setSubViews()
    }
    
    func setSubViews(){
        buttonStack.addArrangedSubview(buttonTwitter)
        buttonStack.addArrangedSubview(buttonFace)
        buttonStack.addArrangedSubview(buttonWhatsapp)
        buttonStack.addArrangedSubview(buttonTelegram)
        addSubview(line1Field)
        addSubview(line2Field)
        addSubview(buttonStack)
        
        NSLayoutConstraint.activate([line1Field.widthAnchor.constraint(equalTo: widthAnchor),
                                     line1Field.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     line1Field.topAnchor.constraint(equalTo: topAnchor),
                                     line1Field.heightAnchor.constraint(equalToConstant: 2),
                                     buttonStack.topAnchor.constraint(equalTo: line1Field.bottomAnchor),
                                     buttonStack.heightAnchor.constraint(equalToConstant: 60),
                                     buttonStack.bottomAnchor.constraint(equalTo:line2Field.topAnchor),
                                     buttonStack.leadingAnchor.constraint(equalTo:leadingAnchor),
                                     buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     line2Field.widthAnchor.constraint(equalTo: widthAnchor),
                                      line2Field.centerXAnchor.constraint(equalTo: centerXAnchor),
                                      line2Field.bottomAnchor.constraint(equalTo: bottomAnchor),
                                      line2Field.heightAnchor.constraint(equalToConstant: 2),
                                      
                                     ])
        
    }
    
    @objc private func whatsAppButtonClicked(){
        guard let comment = comment else {return}
        let urlString = comment.userNick + "\n" + comment.commentText + "\n"
        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
       
       //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"

        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:]) { (success) in
                       if success {
//                           print("WhatsApp accessed successfully")
                       } else {
                           print("Error accessing WhatsApp")
                       }
                   }
           }
    }
    
    @objc private func twitterButtonClicked(){
        guard let comment = comment else {return}
        let tweetText = comment.userNick + "\n" + comment.commentText + "\n"
        let tweetUrl = "www.seslisozlukklon.com/\(comment.entryID)/\(comment.commentID)"
        let tweet  =  "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)"
        let tweetEncoding = tweet.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = NSURL(string: tweetEncoding!)
       
       
       //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"

        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:]) { (success) in
                       if success {
                           print("Twitter accessed successfully")
                       } else {
                           print("Error accessing Twitter")
                       }
                   }
           }
    }
    
    
    @objc private func telegramclicked(){
        guard let comment = comment else {return}
        let tgText = comment.userNick + "\n" + comment.commentText + "\n"
        let tgUrl = "www.seslisozlukklon.com/\(comment.entryID)/\(comment.commentID)"
        let urlString = "tg://msg?text=\(tgText)\(tgUrl) "
        let tgEncoding = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = NSURL(string: tgEncoding!)
        
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.open(url! as URL, options: [:]) { (success) in
                if success {
                print("tg accessed successfully")
            } else {
                print("Error accessing tg")
            }
            }
            
        }
        
    }
    
    @objc private func facebookClicked(){
        print("I will add facebook sdk")
            
        }
    }
    
   
    

    
    

