//
//  MessageSigned.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 18.04.2021.
//

import UIKit


class MessageSignedViewController:MessageCommonController{
    
    let firebaseService = FirebaseService()

    var chats:[Chat]?
    let model = MessageSignedModel()
    
    
    lazy var newMessageButton:UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "plus.message"), style: UIBarButtonItem.Style.done, target: self, action: #selector(newMessageButtonPressed))
        item.tintColor = .systemGreen
        return item
        
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.fetchChats()
        
        model.chatsFetcher = { fetchedChats in
            self.chats = fetchedChats
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        navigationItem.title = "messages"
        navigationItem.rightBarButtonItem = newMessageButton
        navigationItem.searchController?.searchBar.placeholder = "search in my messages"
     
        
        }

  
    @objc func newMessageButtonPressed(){
        let searchVC = SearchUserController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return chats?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell
        if let chats = chats  {
            cautionLabel.removeFromSuperview()
            cell?.chat = chats[indexPath.row]
        }
      
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let chat = chats?[indexPath.row],let messageVC = model.openMessagePage(chat: chat) else { return }
        navigationController?.pushViewController(messageVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "delete", handler: { [self] action, view,_ in
            guard let chatID = chats?[indexPath.row].chatID else { return }
            
            model.deleteChatWithSubCompanents(id:chatID)
            
        })])
    }
}


extension MessageSignedViewController{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}
