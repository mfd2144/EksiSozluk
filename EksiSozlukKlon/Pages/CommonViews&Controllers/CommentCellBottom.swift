//
//  File.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 8.04.2021.
//

import UIKit



class CommentCellBottom: UITableViewCell {
    var comment:CommentStruct?
   

    let commentText:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()

    let likeView:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let favoriteView:UIImageView = {
        let image = UIImageView()
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
        stack.alignment = .fill
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
    let mainView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addSubview(mainView)


    }

    private func setViewGestures(){
        let tapFavorite = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        favoriteView.isUserInteractionEnabled = true
        favoriteView.addGestureRecognizer(tapFavorite)

        let taplike = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeView.isUserInteractionEnabled = true
        likeView.addGestureRecognizer(taplike)


        let tapshare = UITapGestureRecognizer(target: self, action: #selector(shareTapped))
        shareView.isUserInteractionEnabled = true
        shareView.addGestureRecognizer(tapshare)

        let tapMenu = UITapGestureRecognizer(target: self, action: #selector(menuTapped))
        menuView.isUserInteractionEnabled = true
        menuView.addGestureRecognizer(tapMenu)


    }
    @objc func favoriteTapped(){
    }
    @objc  func likeTapped(){
    }
    @objc  func menuTapped(){
    }

    @objc  func shareTapped(){
    }

    private func addcommentText(){
        mainView.addSubview(commentText)
        NSLayoutConstraint.activate([
            commentText.topAnchor.constraint(equalTo: mainView.topAnchor,constant: 10),
            commentText.widthAnchor.constraint(equalTo:mainView.widthAnchor, multiplier: 0.90),
            commentText.centerXAnchor.constraint(equalTo:mainView.centerXAnchor)
        ])
    }

    private func setPersonStack(){
        userLabelStack.addArrangedSubview(userName)
        userLabelStack.addArrangedSubview(entityTime)
        userStack.addArrangedSubview(userLabelStack)
        userStack.addArrangedSubview(avatarPhoto)
        mainView.addSubview(userStack)

        NSLayoutConstraint.activate([
            avatarPhoto.widthAnchor.constraint(equalToConstant: 60),
            avatarPhoto.heightAnchor.constraint(equalToConstant: 60),
            userStack.topAnchor.constraint(equalTo: buttonMainStack.bottomAnchor, constant: 10),
            userStack.bottomAnchor.constraint(equalTo: mainView.bottomAnchor,constant: -20),
            userStack.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.90),
            userStack.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
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
        mainView.addSubview(buttonMainStack)

        NSLayoutConstraint.activate([
            likeView.heightAnchor.constraint(equalToConstant: 25 ),
            likeView.widthAnchor.constraint(equalToConstant: 25),
            buttonMainStack.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.9),
            buttonMainStack.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            buttonMainStack.topAnchor.constraint(equalTo: commentText.bottomAnchor,constant: 10)
        ])
    }

    func fetchInfos(comment:CommentStruct, _ favoriteCondition:Bool,_ likeCondition:Bool) {
        self.comment = comment
        favoriteView.image = favoriteCondition ? UIImage(systemName: "drop.fill") : UIImage(systemName: "drop")
        if likeCondition{
            likeView.image = UIImage(systemName: "chevron.up.square.fill")
            likeView.tintColor = .green
        }else{
            likeView.image = UIImage(systemName: "chevron.up.square")
            likeView.tintColor = .systemGray3
        }

    }

}

