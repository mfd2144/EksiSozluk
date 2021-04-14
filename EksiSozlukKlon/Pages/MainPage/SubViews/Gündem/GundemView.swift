//
//  File.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//


import UIKit


class GundemView:BasicView{
    let tableView = MainTableView()
    let model = GundemModel()
    var entries: [EntryStruct]?
    
    
    let settingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        let label = UILabel()
        label.text = "gündeminizi kişileştirin"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
         
        let button = UIButton()
        button.backgroundColor = .systemBackground
        button.setImage(UIImage(systemName: "slider.vertical.3"), for: .normal)
        button.setTitle("filtrele", for: .normal)
        button.drawCorner()
        button.tintColor = .systemGray2
        button.setTitleColor(.systemGray2, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.30),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
 
        view.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonClicked), for: .touchUpInside)
        return view
    }()
    
 
    
 

    override func startingOptions() {
        super.startingOptions()
        addViews()
        setConstraits()
        tableView.tableView.delegate = self
        tableView.tableView.dataSource = self
        tableView.tableView.register(CommentViewCell.self, forCellReuseIdentifier: "GundemCell")
        
        parentController = { controller in
            self.model.parent = controller as? MainPageController
        }
        
        
        model.entries = { entries in
            self.entries = entries
            self.tableView.tableView.reloadData()
        }
        
    }
    
    func addViews(){
        addSubview(settingView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }
    func setConstraits(){
        NSLayoutConstraint.activate([
            settingView.heightAnchor.constraint(equalToConstant: 60),
            settingView.widthAnchor.constraint(equalTo: widthAnchor),
            settingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingView.topAnchor.constraint(equalTo: topAnchor),
            tableView.topAnchor.constraint(equalTo: settingView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc private func filterButtonClicked(_ sender:UIButton){
        model.showAlert()
 
        
        
    }
}


extension GundemView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: "GundemCell", for: indexPath) as? CommentViewCell else {return UITableViewCell()}
        
        guard let entry = entries?[indexPath.row] else {return cell}
        cell.setCellValues(text: entry.entryLabel, number: entry.comments)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let entry = entries?[indexPath.row] else {return}
        model.callCommentView(row: indexPath.row, entry: entry)
       
    }
    
 

}
