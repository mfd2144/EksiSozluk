//
//  File.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//

import UIKit
import FirebaseAuth

class BugunView:MainTableView{
    
  
    let model = BugunModel()
    var entries: [EntryStruct]?
//    var id:String? // adding to this id to send document or other identification number to parent, thus we can send information to segue

    let addButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGreen
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.imageEdgeInsets = .zero
        button.isHidden = Auth.auth().currentUser == nil ? true : false
        return button
    }()
    
    override func startingOptions() {
        super.startingOptions()
       
        
        tableView.register(EntriesViewCell.self, forCellReuseIdentifier: "CellBugun")
        setAddButton()
        
        // inherit this method from basic view
        parentController = { controller in
            self.model.parent = controller as? MainPageController
        }
        
        //  use closure otherwise entries array come back empty
        model.sendEntity = { entries in
            self.entries = entries
            self.tableView.reloadData()
        }
      
        
    }
    
    func setAddButton(){
        addSubview(addButton)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }
    
    
    @objc func addButtonTapped(_ sender:UIButton){
        model.addNewEntry()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: "CellBugun", for: indexPath) as? EntriesViewCell else {return UITableViewCell()}
        
        guard let entry = entries?[indexPath.row] else {return cell}
       
      
        
        cell.setCellValues(text: entry.entryLabel, number: entry.comments)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let entry = entries?[indexPath.row] else {return}
        model.callCommentView(entry: entry)
       
    }
 
}


