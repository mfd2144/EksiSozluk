//
//  rookieView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 16.05.2021.
//

import Foundation


import Foundation

import UIKit
import FirebaseAuth

class RookieView:MainTableView{
    
  
    let model = RookieModel()
    var entries: [EntryStruct]?
 
   
    
    override func startingOptions() {
        super.startingOptions()
       
        
        tableView.register(EntriesViewCell.self, forCellReuseIdentifier: "CellDebe")
        
        // inherit this method from basic view
        parentController = { controller in
            self.model.parent = controller as? MainPageController
        }
        
        //  use closure otherwise entries array come back empty
        model.sendEntries = { entries in
            self.entries = entries
            self.tableView.reloadData()
        }
      
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: "CellDebe", for: indexPath) as? EntriesViewCell else {return UITableViewCell()}
        
        guard let entry = entries?[indexPath.row] else {return cell}
        cell.setCellValues(text: entry.entryLabel, number: entry.comments)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let entry = entries?[indexPath.row] else {return}
        model.callCommentView(row: indexPath.row, entry: entry)
        
       
    }
 
}
