//
//  CommentNavMenuTopComponent.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 5.04.2021.
//

import UIKit

class CommentNavTopComponent:UIView{
    var delegate :CommentTopNavDelegate?
    let fireservice = FirebaseService()
    var followLogic = false
    var likeLogic = false
    
    var id:String?{
        didSet{
            getFollowCondition()
            getLikeCondition()
        }
    }
    
    let entryLabel:UILabel = {
        let label = UILabel()
        label.text = "entry label"
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
        button.addTarget(self, action: #selector(searchButtonPushed), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton:UIButton = {
        let button = setButton("square.and.arrow.up")
        button.addTarget(self, action: #selector(shareEntityPushed), for: .touchUpInside)
        return button
    }()
    
    lazy var followButton:UIButton = {
        let button = setButton("bell")
        button.addTarget(self, action: #selector(followPushed), for: .touchUpInside)
        return button
    }()
    
    lazy var mostLikedButton:UIButton = {
        let button = setButton("heart")
        button.addTarget(self, action: #selector(showMostLikedPushed), for: .touchUpInside)
        return button
    }()
    
    lazy var searcInEntryButton:UIButton = {
        let button = setButton("slider.vertical.3")
        button.addTarget(self, action: #selector(searhInEntryPushed), for: .touchUpInside)
        return button
    }()
    
    lazy var imageStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mostLikedButton,searcInEntryButton,followButton,shareButton,searchButton])
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
        fireservice.entryDelegate = self
        otherSettings()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func otherSettings(){
        //        for child view
    }
    
    
    
    func setStacks(){
        topComponentStack.addArrangedSubview(entryLabel)
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
    
    func  getFollowCondition(){
        guard let id = id else { return }
        fireservice.fetchFollowCondition(entryID: id) {(error) in
            if let error = error {
                print( "follow condition error \(error.localizedDescription)")
            }
        }
    }
    
    func  getLikeCondition(){
        guard let id = id else { return }
        fireservice.fetchLikeCondition(entryID: id) { (error) in
            if let error = error {
                print( "like condition load error \(error.localizedDescription)")
            }
        }
    }
    
    
    
    @objc func followPushed(){
        
        guard let id = id else { return }
        followButton.isEnabled = false
        fireservice.followUnfollowAnEntity(id) { [self] (error) in
            
            if let error = error{
                DispatchQueue.main.async {
                    print("follow list error \(error.localizedDescription)")
                    followButton.isEnabled = true
                }
        
            }else{
                DispatchQueue.main.async {
                    followLogic = !followLogic
                    setImage(button: followButton, condition: followLogic)
                }
                
            }
        }
    }
    
    @objc func showMostLikedPushed(){
        guard let id = id else { return }
        mostLikedButton.isEnabled = false
        fireservice.likeOrUnlikeAnEntity(id){ [self]  (error) in
            if let error = error {
                print("like list error \(error.localizedDescription)")
                mostLikedButton.isEnabled = true
            }else{
                DispatchQueue.main.async {
                    likeLogic = !likeLogic
                    setImage(button: mostLikedButton, condition: likeLogic)
                }
            }
            
            
            
        }
    }
    @objc func searchButtonPushed(){
        
        delegate?.searchClicked()
        
    }
    @objc func shareEntityPushed(){
        
        delegate?.shareEntityClicked()
        
    }
    
    @objc func searhInEntryPushed(){
        
        delegate?.searhcInEntryClicked()
        
    }
    
    func setImage(button:UIButton,condition:Bool){
        button.isEnabled = true
        if condition {
            button.backgroundColor = .systemGreen
            button.tintColor = .systemBackground
            button.layer.borderColor = UIColor.systemGreen.cgColor
        } else {
            button.backgroundColor = .systemBackground
            button.tintColor = .systemGray3
            button.layer.borderColor = UIColor.systemGray3.cgColor
        }
    }
}


extension CommentNavTopComponent:FireBaseEntryDelegate{
    func decideToEntryLikeCondition(_ fill: Bool) {
        likeLogic = fill
        setImage(button:mostLikedButton,condition:likeLogic)
    }
    
    func decideToFollowCondition(_ fill: Bool) {
        followLogic = fill
        setImage(button: followButton, condition: followLogic)
        
    }
    
    
    
}


protocol CommentTopNavDelegate{
    func searchClicked()
    func shareEntityClicked()
    func searhcInEntryClicked()
    
}
