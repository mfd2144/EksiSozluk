//
//  UserControlModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 12.05.2021.
//

import UIKit

class UserMainPageModel: NSObject{
    let firebaseService = FirebaseService()
    var cell:UITableViewCell?
    var trigger:(([EntryStruct])->())?
    override init() {
        super.init()
    }
    
    func fetchUserEntries(){
        firebaseService.searchMyEntries { entries, error in
            if let error = error {
                print("my entries' loading error \(error.localizedDescription)")
            }else{
                self.trigger?(entries)
            }
        }
    }
    
    
    func fetchLikedEntries(){
        firebaseService.fetchUserDemandedList(true) { (followedList, error) in
            if let error = error{
                print("fetching followed entry list fail \(error.localizedDescription)")
            }else{
                self.searchLikedEntry(followedList)
               
            }
        }
    }
    
    private func searchLikedEntry(_ list: [String]){
        firebaseService.fetchEntriesByList(list) { (entryStruct, error) in
            if let error = error{
                print("fetching user's followed entries fail \(error.localizedDescription)")
            }
            
            let entriesArray = entryStruct.compactMap({ $0 })
            self.trigger?(entriesArray)

            
            
        }
    }
    
    
}
