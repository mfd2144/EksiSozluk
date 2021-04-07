//
//  SingleCommentMain.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 6.04.2021.
//

import UIKit

class SingleCommentMain: UITableViewCell {
    
    var comment:CommentStruct?
    var delegate: CommentMainCellDelegate?

    let commentText:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    let likeView:UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "chevron.up.square"))
        image.tintColor = .systemGray3
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let favoriteView:UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "drop"))
        image.tintColor = .systemGray3
        return image
    }()
    
    let shareView:UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "square.and.arrow.up"))
        image.tintColor = .systemGray3
        return image
    }()
    
    let menuView:UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "ellipsis.rectangle"))
        image.tintColor = .systemGray3
        return image
    }()
    
    let entityTime:UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.textAlignment = .left
        return label
    }()
    
    let favoriteLabel:UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.textAlignment = .center
        return label
    }()
    let userName:UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .left
        return label
    }()
    
    let avatarPhoto:UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.circle"))
        image.tintColor = .systemGray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    func takeDelegate(delegate:CommentMainCellDelegate) {
        self.delegate = delegate
        
    }
    
    let userLabelStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 0
        stack.alignment = .trailing
        
        return stack
    }()
    
    let userStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 0
        stack.alignment = .trailing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let buttonStackLeft:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 10
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let buttonStackRight:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 10
        stack.alignment = .trailing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let buttonMainStack :UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
 

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addcommentText()
        setButtonStacks()
        setPersonStack()
        setCommentToCell()
        setViewGestures()
        
    }
    
    private func setViewGestures(){
        let tapFavorite = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        favoriteView.isUserInteractionEnabled = true
        favoriteView.addGestureRecognizer(tapFavorite)
    }
    @objc private func favoriteTapped(){
        delegate?.favoriteClicked()
        
    }
    
    
    private func addcommentText(){
        self.contentView.addSubview(commentText)
        NSLayoutConstraint.activate([
                                        commentText.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            commentText.widthAnchor.constraint(equalTo:contentView.widthAnchor, multiplier: 0.90),
                                        commentText.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setPersonStack(){
        userLabelStack.addArrangedSubview(userName)
        userLabelStack.addArrangedSubview(entityTime)
        userStack.addArrangedSubview(userLabelStack)
        userStack.addArrangedSubview(avatarPhoto)
        self.contentView.addSubview(userStack)
        
        NSLayoutConstraint.activate([
            avatarPhoto.widthAnchor.constraint(equalToConstant: 60),
            avatarPhoto.heightAnchor.constraint(equalToConstant: 60),
            userStack.topAnchor.constraint(equalTo: buttonMainStack.bottomAnchor, constant: 10),
            userStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20),
            userStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.90),
            userStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setCommentToCell(){
        guard let comment = comment else { return }
        commentText.text = comment.commentText
        entityTime.text = comment.createDate.convertDateToString()
        userName.text = comment.userNick
        favoriteLabel.text = String(comment.favories)
        
      
    }
    
    private func setButtonStacks(){
        buttonStackLeft.addArrangedSubview(likeView)
        buttonStackLeft.addArrangedSubview(favoriteView)
        buttonStackLeft.addArrangedSubview(favoriteLabel)
        buttonStackRight.addArrangedSubview(shareView)
        buttonStackRight.addArrangedSubview(menuView)
        buttonMainStack.addArrangedSubview(buttonStackLeft)
        buttonMainStack.addArrangedSubview(buttonStackRight)
        self.contentView.addSubview(buttonMainStack)
        
        NSLayoutConstraint.activate([
            likeView.heightAnchor.constraint(equalToConstant: 15),
            likeView.widthAnchor.constraint(equalToConstant: 15),
            buttonMainStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            buttonMainStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonMainStack.topAnchor.constraint(equalTo: commentText.bottomAnchor,constant: 10)
        ])
    }
    

}

protocol CommentMainCellDelegate{
    func favoriteClicked()
}
