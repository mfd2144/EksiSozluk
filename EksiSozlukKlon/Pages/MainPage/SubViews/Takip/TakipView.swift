//
//  SorunsallarView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 30.03.2021.
//



import UIKit


class TakipView:BasicView{
    let model = TakipModel()
    var entries: [EntryStruct]?
    var comments: [CommentStruct]?
    var selectedIndex:Int = 0
    let tableView = MainTableView()
    
    
    let emptyView:UIView={
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor =  .systemGray6
        return view
    }()
    
    
    let cautionLabel:UILabel = {
        let label = UILabel()
        label.text = "bu başlıkta aradığınız kriterlere uygun entry bulunamadı."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var settingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        let segment = UISegmentedControl(items: ["entry'ler","favoriler"])
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
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
        tableView.tableView.register(EntriesViewCell.self, forCellReuseIdentifier: "TakipCell")
        tableView.tableView.register(CommenTableCell.self, forCellReuseIdentifier: "TakipCommentTableCell")

        model.selectedIndex?(selectedIndex)
        parentController = { controller in
            self.model.parent = controller as? MainPageController
        }
        
        model.entries = { entries in
            self.entries = entries
            self.tableView.tableView.reloadData()
            
        }
        
        model.comments = { comments in
            self.comments = comments
            self.tableView.tableView.reloadData()
        }
        
    }
    
  
    
    func emptyViewShow(){
        emptyView.addSubview(cautionLabel)
        tableView.addSubview(emptyView)
        NSLayoutConstraint.activate([emptyView.heightAnchor.constraint(equalTo: tableView.tableView.heightAnchor),
                                     emptyView.widthAnchor.constraint(equalTo: tableView.tableView.widthAnchor),
                                     emptyView.leadingAnchor.constraint(equalTo: tableView.tableView.leadingAnchor),
                                     emptyView.topAnchor.constraint(equalTo: tableView.tableView.topAnchor),
                                     cautionLabel.topAnchor.constraint(equalTo: emptyView.topAnchor,constant: 150),
                                    cautionLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
                                    cautionLabel.widthAnchor.constraint(equalTo: emptyView.widthAnchor, multiplier: 0.9)
                                     
        ])
        
    }
    
    func removeEmptyView(){
        emptyView.removeFromSuperview()
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
    
    @objc private func segmentChanged(_ sender: UISegmentedControl){
        model.selectedIndex?(sender.selectedSegmentIndex)
        selectedIndex = sender.selectedSegmentIndex
        tableView.tableView.reloadData()
    }
    
    
}


extension TakipView:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == 0{
            entries == nil || entries == [] ?  emptyViewShow() : removeEmptyView()
            return entries?.count ?? 0
        }else{
            comments == nil || comments == [] ?  emptyViewShow() : removeEmptyView()
            return comments?.count ?? 0
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedIndex == 0{
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: "TakipCell", for: indexPath) as? EntriesViewCell else {return UITableViewCell()}
        
        guard let entry = entries?[indexPath.row] else {return cell}
        cell.setCellValues(text: entry.entryLabel, number: entry.comments)
        return cell
        }else{
            guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: "TakipCommentTableCell", for: indexPath) as? CommenTableCell,let comment = comments?[indexPath.row]  else {return UITableViewCell()}
            cell.parentController = model.parent
            cell.comment = comment
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == 0{
        guard let entry = entries?[indexPath.row] else {return}
        model.callCommentView(row: indexPath.row, entry: entry)
        }else{
            tableView.deselectRow(at: indexPath, animated: true)
            guard let comment = comments?[indexPath.row] else { return }
            let singleCommentVC = SingleCommentViewController()
            
            singleCommentVC.comment = comment
            // send single comment information via navbar to
            model.parent?.present(singleCommentVC, animated: true, completion: nil) 
        }
    }
  
}

