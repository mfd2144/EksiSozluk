//
//  UserControlMain.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 11.05.2021.
//

import UIKit

class UserMainPageController:UITableViewController{

    
    
    var entries :[EntryStruct]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    let model = UserMainPageModel()
    
    lazy var settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName:"gearshape") , style: .plain, target: self, action: #selector(menuPressed))
        button.tintColor = .systemGreen
        return button
    }()
    
    lazy var segmentControl:UISegmentedControl = {
        let segment = UISegmentedControl(items: ["entry'ler","beğenilenler"])
        segment.addTarget(self, action: #selector(segmentSelected(_:)), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentSelected(segmentControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = settingsButton
        tableView.register(EntriesViewCell.self, forCellReuseIdentifier: EntriesViewCell.cellID)
        tableView.register(StaticUserCell.self, forCellReuseIdentifier: StaticUserCell.staticCellIdentifier)
        
        model.trigger = { sentEntries in
            self.entries = sentEntries
        }
       
    }

    
    
    @objc func segmentSelected(_ sender:UISegmentedControl!){
      if sender.selectedSegmentIndex == 0{
        model.fetchUserEntries()
        }else{
            model.fetchLikedEntries()
        }
    }
    
    
    @objc func menuPressed(){
        let settingsController = SettingsViewController()
        navigationController?.pushViewController(settingsController, animated: true)
    }
    
    
}


extension UserMainPageController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return entries?.count ?? 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: StaticUserCell.staticCellIdentifier, for: indexPath)
            return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier:EntriesViewCell.cellID, for: indexPath) as? EntriesViewCell
            let entry = entries?[indexPath.row]
            cell?.setCellValues(text: entry!.entryLabel, number: entry!.comments)
            return cell ?? UITableViewCell()
        }
    }
  
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            return segmentControl
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 1  ? 40 : 0
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let entry = entries?[indexPath.row] else { return }
       
        let commentVC = CommentsTableViewController()
        commentVC.entry = entry
        navigationController?.pushViewController(commentVC, animated: true)
        
    }
    
    
}
