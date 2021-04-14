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
        firebaseService.fetchEntities(today: true){ (entities, error) in
            if let _ = error{
                print("entity fetching error\(error!.localizedDescription)")
            }else{
                self.sendEntity?(entities)
            }
        }
    }
    
    
    func addNewEntryToService(_ text:String,category:String){
        guard let userID = firebaseService.user?.uid else {return}
        let entry = EntryStruct(entryLabel: text, comments: 0, userID: userID,category: category )
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
        alert.addTextField { (textField) in
            
        }
        
        alert.addAction(cancelAction)
        
        
        //       picker handler
        class PickerHandler: NSObject, UIPickerViewDelegate, UIPickerViewDataSource{
            var items: [String]
            lazy var lastSelectedItem = items[0]
            
            init(items: [String]){
                self.items = items
                super.init()
            }
            
            func numberOfComponents(in pickerView: UIPickerView) -> Int {
                return 1
            }
            
            func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                return items.count
            }
            
            func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
                return items[row]
            }
            
            func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                lastSelectedItem = items[row]
            }
            
            
            
        }
        DispatchQueue.main.async { [weak self] in
            
            let handler = PickerHandler(items: ["ilişki","yetişkin","diğer","siyasi","spor"])
            let pickerView = UIPickerView(frame: .zero)
            alert.view.addSubview(pickerView)
            
            pickerView.delegate = handler
            pickerView.dataSource = handler
            pickerView.selectRow(2, inComponent: 0, animated: false)
            let selectAction = UIAlertAction(title: "kaydet", style: .default) { (action) in
               
                guard let text = alert.textFields?.first?.text, text != ""  else {return}
                self!.addNewEntryToService(text,category : handler.lastSelectedItem)
            }
            
            alert.addAction(selectAction)
            
            
            pickerView.translatesAutoresizingMaskIntoConstraints = false
            
            let constantAbovePicker: CGFloat = 70
            let constantBelowPicker: CGFloat = 50
            
            NSLayoutConstraint.activate([
                pickerView.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant:  10),
                pickerView.widthAnchor.constraint(equalToConstant: 250),
                pickerView.widthAnchor.constraint(lessThanOrEqualTo: alert.view.widthAnchor, constant: 20),
                
                pickerView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant:  constantAbovePicker),
                pickerView.heightAnchor.constraint(equalToConstant: 150),
                alert.view.bottomAnchor.constraint(greaterThanOrEqualTo: pickerView.bottomAnchor, constant:  constantBelowPicker),
            ])
            
            self!.parent?.present(alert, animated: true, completion: nil)
        }
    }
}
