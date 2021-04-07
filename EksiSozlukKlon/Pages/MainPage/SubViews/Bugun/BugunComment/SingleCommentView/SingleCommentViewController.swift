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
    var favoriteCondition = false
    override func viewDidLoad() {
        super.viewDidLoad()
        model.comment = comment
        setTableView()
    }

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCommentMain", for: indexPath) as? SingleCommentMain else {return UITableViewCell()}
            
            cell.contentView.isUserInteractionEnabled = true
            cell.comment = self.comment
            cell.sendInfos(self, favoriteCondition)
            return cell
        }else{
          guard  let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCommentBottom", for: indexPath) as? SingleCommentBottom else {return UITableViewCell()}
            return cell
            }
    }
  
   private func setTableView(){
        
        tableView.register(SingleCommentMain.self, forCellReuseIdentifier: "SingleCommentMain")
        tableView.register(SingleCommentBottom.self, forCellReuseIdentifier: "SingleCommentBottom")
        tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = true
        tableView.separatorStyle = .none
    model.firebaseService.cellDelegate = self
    }
   
}

extension SingleCommentViewController:FireBaseCellDelegate{
    func decideToFavoriteImage(_ fill: Bool) {
        self.favoriteCondition = fill
        tableView.reloadData()
    }
    
    
}

extension SingleCommentViewController:CommentMainCellDelegate{
    func favoriteClicked() {
        model.addorRemoveToFavorites()
    }
    
    
}
