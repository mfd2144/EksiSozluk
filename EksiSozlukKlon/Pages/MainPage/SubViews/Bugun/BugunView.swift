//
//  File.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//

import UIKit


class BugunView:MainTableView{

    
    override func startingOptions() {
        super.startingOptions()
        
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.cellForRow(at: indexPath) else {return UITableViewCell()}
//        cell.textLabel?.text = "bu iş burada biter"
//        return cell
//    }
    
   
}
