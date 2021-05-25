//
//  UpdateTableViewController.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 17.05.2021.
//

import UIKit

class UpdateTableViewController: UITableViewController {
    
    var entries:[EntryStruct]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    let model = UpdateModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let tabItem = self.navigationController?.tabBarItem else {return}
        tabItem.badgeValue = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(EntriesViewCell.self, forCellReuseIdentifier: EntriesViewCell.cellID)
        entries = AppSingleton.shared.followedUsersLastEntries
    }

    // MARK: - Table view data source

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntriesViewCell.cellID, for: indexPath) as? EntriesViewCell, let entry = entries?[indexPath.row] else { return UITableViewCell()}

        cell.setCellValues(text: entry.entryLabel, number: entry.comments)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let entry = entries?[indexPath.row] else {return}
        let commentNavVC = CommentNavController()
        commentNavVC.modalPresentationStyle = .fullScreen
        commentNavVC.entry = entry
       presentToRight(commentNavVC)
       
    }

}
