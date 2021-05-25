//
//  CommentViewModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 5.04.2021.
//

import UIKit

class CommentsTableModel: NSObject {
    
    var commentsContainer:(([CommentStruct])->())?
    let firebaseService = FirebaseService()
    var comments:[CommentStruct]?
  
    var totalPage:Int = 1
    var totalTableHeight:CGFloat = 0
    var currentPage:Int?{
        didSet{
            setPageNumber()
        }
    }
    var actualTableHeight:CGFloat?
    
    var parentController:CommentsTableViewController?{
        didSet{
            tableView = parentController!.tableView.tableView
        }
    }
    
    var tableView: UITableView?
    
   let picker:UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
    picker.backgroundColor = .systemGray6
        return picker
    }()

    
    override init() {
        super.init()
        currentPage = 1
    }
    
    
    
    func fetchComments(documentID:String?){
        guard let id = documentID else {return}
        firebaseService.fetchComments(documentID:id) { [self] (_comments, error) in
            if let _ = error {
                print("Fetching comments error \(error!.localizedDescription)")
            }else{
                self.comments = _comments
                commentsContainer?(_comments)
            }
        }
    }
    
    func newAlert(id:String?)->UIAlertController{
        
        let alertView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionAll = UIAlertAction(title: "tümü", style: .default) { (_) in
            self.fetchComments(documentID: id)
        }
        
        
        let actionLike = UIAlertAction(title: "beğendiklerim", style: .default) { (_) in
            guard let id = id else{return}
            self.firebaseService.searchCommentsLikedByUser(docID: id) { [self] commentsID, error in
                if let error = error {
                    print("liked comments loading error: \(error)")
                }else{
                    
                    //                    if empty array returns app doesn't do any of bellow sentences
                    guard commentsID != [] ,let comments = comments else {return}
            
                    var listComID = commentsID
                    var commentsArray = [CommentStruct]()
    
                        comments.forEach({ comment in
                            for (index,id) in listComID.enumerated(){
                                if comment.commentID == id{
                                    commentsArray.append(comment)
                                    listComID.remove(at: index)
                                    return
                                }
                            }
                        })
                    self.comments = commentsArray
                        commentsContainer?(commentsArray)
                }
                
            }
        }
        
        
        
        let actionMyComment = UIAlertAction(title: "benimkiler", style: .default) { (_) in
            guard let id = id else{return}
            self.firebaseService.searchMyComments(docID:id) { _comments, error in
                if let error = error{
                    print("Fetching comments error \(error.localizedDescription)")
                }
                self.comments = _comments
                self.commentsContainer?(_comments)
            }
        }
        let actionCancel = UIAlertAction(title: "vazgeç", style: .cancel)
        alertView.addAction(actionAll)
        alertView.addAction(actionLike)
        alertView.addAction(actionMyComment)
        alertView.addAction(actionCancel)
        
        return alertView
    }
    
    
    func searchKeyWord(_ documentID:String?, _ keyWord: String){
        guard let id = documentID else {return}
        firebaseService.fetchComments(documentID: id, keyWord: keyWord) { [self] (_comments, error) in
            if let _ = error {
                print("Fetching comments error \(error!.localizedDescription)")
            }else{
                commentsContainer?(_comments)
            }
        }
        
    }
    
//    func findTotalPage(tableView:inout UITableView)
    func findTotalPage(){
        guard let tableView = tableView else {return}
        actualTableHeight = tableView.frame.height
        guard let commetTotalNumber =  comments?.count, commetTotalNumber != 0 else {totalPage = 1;return}
        
        
//        for i in 0...commetTotalNumber-1{
//            let height = tableView.cellForRow(at: IndexPath(row: i, section: 0))?.frame.height
//            if height != nil{
//                totalTableHeight += height!
//            }else{
//                let indexPath = IndexPath(row: i, section: 0)
//                tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//                let height = tableView.cellForRow(at: IndexPath(row: i, section: 0))?.frame.height
//                totalTableHeight += height!
//            }
//        }
        
//        totalPage = Int(ceil(totalTableHeight/actualTableHeight!))
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    func addAndSetPicker(){
        pickerActivate()
        guard let view = parentController?.view else {return}
       
        view.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.widthAnchor.constraint(equalTo: view.widthAnchor),
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.heightAnchor.constraint(equalToConstant: 300),
            picker.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }

    
    
   private func pickerActivate(){
        picker.dataSource = self
        picker.delegate = self
    
    }
    
    
    
    
    
}

extension CommentsTableModel:UIPickerViewDataSource,UIPickerViewDelegate{
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    "\(String(row+1))/\(totalPage)"
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        totalPage
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentPage = row+1
        tableView!.scrollRectToVisible(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0 ), animated: false)
        tableView!.scrollRectToVisible(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat(currentPage!)*actualTableHeight! ), animated: false)
       
        self.picker.removeFromSuperview()
    }
    
}


extension CommentsTableModel:PageControlDelegate,PageControlDataSource{
   
    func nextPage() {
    
        guard let tableView = tableView ,actualTableHeight != nil, currentPage != nil else {return}
      
        if currentPage! < totalPage{
            currentPage! += 1
            tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat(currentPage!)*actualTableHeight! ), animated: false)
     
        }
    }
    
    
    func previousPage() {
        guard let tableView = tableView, actualTableHeight != nil, currentPage != nil else {return}
     
        if currentPage! > 1{
       currentPage! -= 1
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat(currentPage!)*actualTableHeight! ), animated: false)
            
        }
    }
    
    
    func lastPage() {
        guard let tableView = tableView, currentPage != nil, let commetTotalNumber =  comments?.count,commetTotalNumber != 0 else {return}
        tableView.scrollToRow(at: IndexPath(row: (commetTotalNumber-1), section: 0), at: .top, animated: false)
        currentPage = totalPage
        
    }
    
    
    func firstPage(){
        guard let tableView = tableView else {return}
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        currentPage = 1
     
    }
    
    
    func goToPage(page: Int) {
       addAndSetPicker()
    }
    
    func returnTotalPage() -> Int? {
        return totalPage
    }
    
    func setPageNumber(){
       
        guard let controller = parentController, currentPage != nil else {return}
        print("set")
        controller.commentNavMenuView.labelPageNumber.text = "\(String(currentPage!))/\(String(totalPage))"
    }
}
