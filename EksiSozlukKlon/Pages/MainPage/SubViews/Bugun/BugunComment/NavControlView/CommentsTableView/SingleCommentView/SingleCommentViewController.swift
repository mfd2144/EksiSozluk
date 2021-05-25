//
//  SingleTableViewController.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 5.04.2021.
//

import UIKit

class SingleCommentViewController: UITableViewController {
    
    var cellModel: CommentCellBottomModel?
    var comment:CommentStruct!
    var favoriteCondition = false
    var likeCondition = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        cellModel = CommentCellBottomModel(self, comment: comment)
        cellModel?.delegate = self
    }

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCommentMain", for: indexPath) as? SingleCommentMain else {return UITableViewCell()}
            cell.contentView.isUserInteractionEnabled = true
            cell.fetchInfos(comment:comment , favoriteCondition,likeCondition)
            cell.fetchDelegate(delegate: self)
            return cell
        }else{
          guard  let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCommentBottom", for: indexPath) as? SingleCommentBottom else {return UITableViewCell()}
            cell.comment = comment
            return cell
            }
    }
  
   private func setTableView(){
        
        tableView.register(SingleCommentMain.self, forCellReuseIdentifier: "SingleCommentMain")
        tableView.register(SingleCommentBottom.self, forCellReuseIdentifier: "SingleCommentBottom")
        tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = true
        tableView.separatorStyle = .none
    }
   
}


extension SingleCommentViewController:CommentMainCellDelegate{
    func shareClicked() {
        cellModel?.shareClicked()
    }
    
    func menuClicked() {
        cellModel?.menuClicked()
        
    }
    
   
    
    func likeClicked() {
        cellModel?.likeClicked()
       
    }
    
    func favoriteClicked() {
        cellModel?.favoriteClicked()
    }

    
}


extension SingleCommentViewController:CommentCellBottomModelDelegate{
    func sendInfos(_ likeCondition: Bool, _ favoriteCondition: Bool, comment: CommentStruct) {
        self.likeCondition = likeCondition
        self.favoriteCondition = favoriteCondition
        self.comment = comment
        tableView.reloadData()
    }

}

