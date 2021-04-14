//
//  GundemModelVİew.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 10.04.2021.
//

import UIKit

class GundemModel:NSObject{
    var settings :Dictionary<String,Bool>?
    let firebase = FirebaseService()
    var entries:(([EntryStruct])->())?
    var parent:UIViewController?
    
    override init() {
        super.init()
       loadSettings()
     
    }
    func loadSettings(){
        settings = GundemSettings.fetchStartingSettings()
        loadEntries()
    }
    func loadEntries(){
        firebase.fetchEntitiesAccordingToSettings { [self] (entryStruct, error) in
            if let error = error {
                print("Gundem page fetching entry error \(error.localizedDescription)")
                
            }
            entries?(entryStruct)
            
        }
    }
    
    func showAlert(){
        let alert = CustomAlert()
        alert.settings = settings
        alert.modalPresentationStyle = .overFullScreen
        alert.delegate = self
        parent?.present(alert, animated: true, completion: nil)
    }
    
    func callCommentView(row:Int,entry:EntryStruct){
        let commentNavVC = CommentNavController()
        commentNavVC.modalPresentationStyle = .fullScreen
        commentNavVC.entry = entry
        (parent?.view.window?.windowScene?.delegate as? SceneDelegate)?.id = entry.documentID
        parent?.presentToRight(commentNavVC)
        
        
    }
    
}

extension GundemModel:CustomAlertDelegate{
    func settingsDidChanged() {
       loadEntries()
    }
    
    
}
