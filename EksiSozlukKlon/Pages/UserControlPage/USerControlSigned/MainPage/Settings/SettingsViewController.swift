//
//  TableViewController.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 18.05.2021.
//

import UIKit

class SettingsViewController: UITableViewController {
    let model = SettingsModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        model.parentController = self
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
    }
    
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        return model.setCell(indexPath: indexPath, cell)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.selectViewController(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
   
    
}
