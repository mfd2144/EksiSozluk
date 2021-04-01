//
//  SorunsallarView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 30.03.2021.
//



import UIKit


class Sorunsallar:BasicView{
    let tableView = MainTableView()
    
    let settingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        let segment = UISegmentedControl(items: ["gündem","bugün"])
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segment)
        NSLayoutConstraint.activate([
            segment.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            segment.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            segment.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            segment.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
       
        ])
 
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
 

    override func startingOptions() {
        super.startingOptions()
        addViews()
        setConstraits()
       
        tableView.tableView.delegate = self
        tableView.tableView.dataSource = self
        tableView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
}
extension Sorunsallar:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
        cell.textLabel!.text = "başka"
        return cell
    }

}

