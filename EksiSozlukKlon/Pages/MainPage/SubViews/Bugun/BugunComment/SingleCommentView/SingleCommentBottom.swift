//
//  SingleCommentBottom.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 6.04.2021.
//

import UIKit

class SingleCommentBottom: UITableViewCell {

    let commentText:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    let likeView:UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "chevron.up.square"))
        return image
    }()
    
    let entityTime:UILabel = {
        let label = UILabel()
        label.textColor = .systemGray6
        label.backgroundColor = .blue
        return label
    }()
    
    let userName:UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.backgroundColor = .blue
        return label
    }()
    
    let avatarPhoto:UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.circle"))
        return image
    }()
    
    let userLabelStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.alignment = .trailing
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let userStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 0
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    
  

}
