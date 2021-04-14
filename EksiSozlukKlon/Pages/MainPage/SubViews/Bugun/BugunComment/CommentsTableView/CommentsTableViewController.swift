//
//  CommentViewController.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 3.04.2021.
//

import UIKit
import FirebaseAuth

class CommentsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let model = CommentsTableModel()
    var navBarHeight:CGFloat?
    var comments:[CommentStruct]?
    var id :String?
    
    let tableView :MainTableView = {
        let view = MainTableView()
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    let commentNavMenuView:CommentNavMenuView = {
        let view = CommentNavMenuView()
        return view
    }()
    
    lazy var addCommentButton:UIBarButtonItem = {
        let button = UIBarButtonItem(image:UIImage(systemName: "square.and.pencil"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(addClicked))
        button.tintColor = .systemGreen
        return button
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let barButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem = barButton
        navigationItem.rightBarButtonItem = addCommentButton
        navBarHeight = self.navigationController?.navigationBar.frame.maxY
        setViews()
        view.addSubview(tableView)
        view.addSubview(commentNavMenuView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.tableView.delegate = self
        tableView.tableView.dataSource = self
        commentNavMenuView.delegate = self
        
        tableView.tableView.register(CommenTableCell.self, forCellReuseIdentifier: "CommentTableCell")
        
        //        program add id to sceneDelegate ,thus take information there
        id = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.id
        model.fetchComments(documentID: id!)
        model.comments = { commetsArray in
            self.comments = commetsArray
            self.tableView.tableView.reloadData()
        }
        
        
    }
    
    @objc func dismissView(_ sender:UIBarButtonItem){
        dissmisToLeft()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableCell", for: indexPath) as? CommenTableCell,let comment = comments?[indexPath.row] else {return UITableViewCell()}
        cell.parentController = self
        cell.comment = comment
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let comment = comments?[indexPath.row] else { return }
        
        let singleCommentVC = SingleCommentViewController()
        singleCommentVC.comment = comment
        // send single comment information via navbar to 
        navigationController?.pushViewController(singleCommentVC, animated: true)
        
    }
    
}






//MARK: - Top View Swipe act
extension CommentsTableViewController{
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentYtransition =  scrollView.panGestureRecognizer.translation(in: tableView).y
        if currentYtransition<0{
            // swipe down
            UIView.animate(withDuration: 1) {
                if  currentYtransition >= -100 && self.commentNavMenuView.frame.maxY >= (self.navBarHeight)!{
                    
                    self.tableView.frame.origin.y += currentYtransition
                    self.commentNavMenuView.frame.origin.y += currentYtransition
                    self.tableView.frame.size.height -= currentYtransition
                    if self.commentNavMenuView.frame.maxY < (self.navBarHeight)!{
                        self.commentNavMenuView.frame.origin.y = (self.navBarHeight)!-100
                        let newTableSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height-self.navBarHeight!)
                        self.tableView.frame = CGRect(origin: CGPoint(x: 0, y: self.navBarHeight!), size: newTableSize)
                    }
                    
                }
            }
        }else if currentYtransition>0 {
            //    swipe up
            UIView.animate(withDuration: 0.5) {
                if  currentYtransition <= 100 && self.commentNavMenuView.frame.maxY <= (self.navigationController?.navigationBar.frame.maxY)!+100 {
                    self.tableView.frame.size.height -= currentYtransition
                    self.commentNavMenuView.frame.origin.y += currentYtransition
                    self.tableView.frame.origin.y += currentYtransition
                    if self.commentNavMenuView.frame.maxY > (self.navBarHeight)!{
                        self.setViews()
                    }
                }
            }
        }
    }
    
    func setViews(yValue:CGFloat = 0){
        
        guard let navMaxY = navBarHeight else {return}
        let commentSize = CGSize(width: UIScreen.main.bounds.width, height:100)
        let commentRect = CGRect(origin: CGPoint(x: 0, y: navMaxY+yValue), size: commentSize)
        commentNavMenuView.frame = commentRect
        let tableViewTop = commentNavMenuView.frame.maxY
        let tableSize = CGSize(width: view.frame.width, height:view.frame.height-tableViewTop)
        let tableRect = CGRect(origin: CGPoint(x: 0, y: tableViewTop+yValue), size: tableSize)
        tableView.frame = tableRect
        
    }
    
    @objc private func addClicked(){
        let addController = AddNewCommentViewController()
        addController.commentString = (self.navigationController as? CommentNavController)?.entry?.entryLabel
        guard let _ = Auth.auth().currentUser else {return}
        present(addController, animated: true, completion: nil)
    }
    
    
}

extension CommentsTableViewController:CommentTopNavDelegate{
    func followClicked() {
        //        firebaseservice will handle here
    }
    
    func searhInEntryClicked() {
        let alert = model.newAlert()
        present(alert, animated: true, completion: nil)
    }
    
    func showMostLikedClicked() {
//        firebaseservice will handle here
    }
    
    func searchClicked() {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        commentNavMenuView.addViewWithAnimation(searchBar)
        NSLayoutConstraint.activate([searchBar.topAnchor.constraint(equalTo: commentNavMenuView.topAnchor),
                                     searchBar.bottomAnchor.constraint(equalTo: commentNavMenuView.bottomAnchor,constant: -40),
                                     searchBar.trailingAnchor.constraint(equalTo: commentNavMenuView.trailingAnchor),
                                     searchBar.leadingAnchor.constraint(equalTo: commentNavMenuView.leadingAnchor)

                                        
        ])
  searchBar.delegate = self
        
    }
    func shareEntityClicked(){
    
        let ac = UIActivityViewController(activityItems: ["www.eksisozlukklon.com/\(id ?? "error")"], applicationActivities: nil)
        present(ac, animated: true, completion: nil)
    }
    
    
}

extension CommentsTableViewController: UISearchBarDelegate{
 
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        model.fetchComments(documentID: id)
        searchBar.removeFromSuperview()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text != ""{
            model.searchKeyWord(id, searchBar.text!)
            tableView.tableView.reloadData()
        }
    }
    
    }
