//
//  SingleCommentMain.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 6.04.2021.
//

import UIKit

class SingleCommentMain:CommentCellBottom  {
    var delegate: CommentMainCellDelegate?
 

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        NSLayoutConstraint.activate([mainView.topAnchor.constraint(equalTo: topAnchor),
                                     mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     mainView.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    override func favoriteTapped() {
        delegate?.favoriteClicked()
    }
    
    override func likeTapped() {
        delegate?.likeClicked()
    }
   
    override func shareTapped() {
        delegate?.shareClicked()
    }
    
    override func menuTapped() {
        delegate?.menuClicked()
    }
    
    func fetchDelegate(delegate:CommentMainCellDelegate){
        self.delegate = delegate
    }
   

}


protocol CommentMainCellDelegate{
    func favoriteClicked()
    func likeClicked()
    func shareClicked()
    func menuClicked()
}








