//
//  DebeView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//

import Foundation

import UIKit
import FirebaseAuth

class DebeView:MainTableView{
    
  
    let model = DebeModel()
    var entries: [EntryStruct]?
    var id:String? // adding to this id to send document or other identification number to parent, thus we can send information to segue
    
   
    
    override func startingOptions() {
        super.startingOptions()
       
        
        tableView.register(CommentViewCell.self, forCellReuseIdentifier: "CellDebe")
        
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
    
   
  
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: "CellDebe", for: indexPath) as? CommentViewCell else {return UITableViewCell()}
        
        guard let entry = entries?[indexPath.row] else {return cell}
        cell.setCellValues(text: entry.entryLabel, number: entry.comments)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let entry = entries?[indexPath.row] else {return}
        model.callCommentView(row: indexPath.row, entry: entry)
       
    }
 
}
