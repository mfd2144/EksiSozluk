//
//  SearchUser.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 19.04.2021.
//

import UIKit
import Firebase

class SearchUserController:MessageCommonController{
    let firebaseservice = FirebaseService()
    var users :[BasicUserStruct]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchUserCell")
        navigationItem.title = "kullanıcı ara"
       
        navigationItem.searchController?.searchBar.placeholder = "kullanıcılırda ara"
        }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users?.count == nil{
            addCautionText()
        }
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserCell", for: indexPath)
        cell.textLabel?.text = users?[indexPath.row].nick
        cautionLabel.removeFromSuperview()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBarController.searchBar.text = ""
        searchBarController.resignFirstResponder()
        guard let selectedUser = users?[indexPath.row] else {return}
        users = nil
        let sendMessageVC = SendMessageViewController()
        sendMessageVC.contactedUser = selectedUser
        navigationController?.pushViewController(sendMessageVC, animated: true)
        
    }
    
}

extension SearchUserController{
    
     func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
      
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchBar.text?.lowercased()
        firebaseservice.stopListener()
        if searchBar.text!.count > 3 && searchBar.text != "   "   {
            firebaseservice.searchForUser(keyWord: searchBar.text!){ (users,error) in
                if let error = error {
                    print("user search error \(error.localizedDescription)")
                }else{
                    self.users = users
                }
            }
        }else{
            users = nil
        }
    }
   

    
    
}
