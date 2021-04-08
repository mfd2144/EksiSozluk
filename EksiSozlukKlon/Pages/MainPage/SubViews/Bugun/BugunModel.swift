//
//  BugunModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 2.04.2021.
//

import UIKit
import Firebase

class BugunModel:NSObject{
    
    let firebaseService = FirebaseService()
    var sendEntity:(([EntryStruct])->())?
    var parent:UIViewController? //we chose parent as a view controller, thus we can use some method in parent controller
       
    
    
    override init() {
        super.init()
        firebaseService.fetchEntities{ (entities, error) in
            if let _ = error{
                print("entity fetching error\(error!.localizedDescription)")
            }else{
                self.sendEntity?(entities)
            }
        }
    }
  
    
    func addNewEntryToService(_ text:String){
        guard let userID = firebaseService.user?.uid else {return}
        let entry = EntryStruct(entryLabel: text, comments: 0, userID: userID )
        firebaseService.addNewEntity(entry: entry)
    }
    
    func callCommentView(row:Int,entry:EntryStruct){
        let commentNavVC = CommentNavController()
        commentNavVC.modalPresentationStyle = .fullScreen
        commentNavVC.entry = entry
        (parent?.view.window?.windowScene?.delegate as? SceneDelegate)?.id = entry.documentID
        parent?.presentToRight(commentNavVC)
        
        
    }
    
    func addNewEntry(){
       
        let alert = UIAlertController(title: "entity giriş", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "vazgeç", style: .cancel, handler: nil)
        let enterAction = UIAlertAction(title: "kaydet", style: .default) { (action) in
            guard let text = alert.textFields?.first?.text else {return}
            self.addNewEntryToService(text)
        }
        alert.addTextField { (textField) in
            
        }
        alert.addAction(enterAction)
        alert.addAction(cancelAction)
        parent?.present(alert, animated: true, completion: nil)
    }
    
}
