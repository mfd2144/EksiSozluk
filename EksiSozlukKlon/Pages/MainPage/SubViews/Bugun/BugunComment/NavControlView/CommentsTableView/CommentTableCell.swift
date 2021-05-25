//
//  CommentTableCell.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 8.04.2021.
//

import UIKit

class CommenTableCell: CommentCellBottom {
    
    var bottomCellModel :CommentCellBottomModel?
    var parentController:UIViewController?{
        didSet{
           
            guard  let comment = comment else { return }
            bottomCellModel = CommentCellBottomModel(parentController!, comment: comment)
            
            
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        NSLayoutConstraint.activate([mainView.topAnchor.constraint(equalTo: topAnchor),
                                     mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     mainView.trailingAnchor.constraint(equalTo: trailingAnchor)])
        
        fetchInfos(comment: comment!, false, false)
        
    }
    
    


override func favoriteTapped() {

}

override func likeTapped() {
  
}

override func shareTapped() {
    bottomCellModel?.shareClicked()
}

override func menuTapped() {
    bottomCellModel?.menuClicked()
}
    
    
override func fetchInfos(comment: CommentStruct, _ favoriteCondition: Bool, _ likeCondition: Bool) {
        favoriteLabel.text = String(comment.favories)
        likeView.removeFromSuperview()
        favoriteView.image = UIImage(systemName: "drop")
    }
}



extension CommenTableCell:CommentCellBottomModelDelegate{
    func sendInfos(_ likeCondition: Bool, _ favoriteCondition: Bool, comment: CommentStruct) {
        fetchInfos(comment: comment, favoriteCondition, likeCondition)
    }
}












