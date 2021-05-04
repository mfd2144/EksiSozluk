//
//  MessageSigned.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 18.04.2021.
//

import UIKit


class MessageCommonController:UITableViewController,UISearchBarDelegate{
    
    

    
    let cautionLabel :UILabel = {
        let label = UILabel()
        label.text = "yok ki öyle birşey"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.backgroundColor = .systemGray6
        return label
    }()
    
    let searchBarController = UISearchController(searchResultsController:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        
    
     
       
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBarController.searchBar.delegate = self
        searchBarController.searchBar.backgroundColor = .systemBackground
        
        if tableView.numberOfRows(inSection: 0) == 0{
            addCautionText()
        }
        
    }
    
    
    func addCautionText(){
        view.addSubview(cautionLabel)
        NSLayoutConstraint.activate([
            cautionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cautionLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 200)
        ])
    }

    
    
    
}
