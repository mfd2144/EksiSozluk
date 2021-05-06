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
        settings = AgendaSettings.fetchStartingSettings()
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
        alert.modalPresentationStyle = .overFullScreen
        alert.delegate = self
        parent?.present(alert, animated: true, completion: nil)
    }
    
    func callCommentView(row:Int,entry:EntryStruct){
        loadSettings()
        let commentNavVC = CommentNavController()
        commentNavVC.modalPresentationStyle = .fullScreen
        commentNavVC.entry = entry
        AppSingleton.shared.entryID = entry.documentID
        parent?.presentToRight(commentNavVC)
        
        
    }
    
}

extension GundemModel:CustomAlertDelegate{
    func settingsDidChanged() {
       loadEntries()
    }
    
    
}
