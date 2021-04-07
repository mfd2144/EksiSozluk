//
//  SingleTableViewController.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 5.04.2021.
//

import UIKit

class SingleCommentViewController: UITableViewController {

    var comment:CommentStruct!
    let model = SingleCommentModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SingleCommentMain.self, forCellReuseIdentifier: "SingleCommentMain")
        tableView.register(SingleCommentBottom.self, forCellReuseIdentifier: "SingleCommentBottom")
        tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = true
        tableView.separatorStyle = .none
       
    }

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCommentMain", for: indexPath) as? SingleCommentMain else {return UITableViewCell()}
            cell.takeDelegate(delegate: self)
            cell.contentView.isUserInteractionEnabled = true
            cell.comment = self.comment
            return cell
        }else{
          guard  let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCommentBottom", for: indexPath) as? SingleCommentBottom else {return UITableViewCell()}
            return cell
            }
    }
  
    
   
}

extension SingleCommentViewController:CommentMainCellDelegate{
    func favoriteClicked() {
        model.addorRemoveToFavorites(comment: comment)
    }
    
    
}
