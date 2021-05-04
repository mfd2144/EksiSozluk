//
//  TakipModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 15.04.2021.
//

import UIKit



class TakipModel:NSObject{
    
    var selectedIndex:((Int)->())?
    let firebaseService = FirebaseService()
    var parent:UIViewController?
    var entries:(([EntryStruct])->())?
    var comments:(([CommentStruct])->())?
    
    override init() {
        super.init()
        selectedIndex = { [self] selectedIndex in
            selectedIndex == 0 ? searchFollowedEntryList() : searchFavoriteCommentList()
        }
        
    }
    
    
    func searchFollowedEntryList(){
        firebaseService.fetchUserFollowList { (followedList, error) in
            if let error = error{
                print("fetching followed entry list fail \(error.localizedDescription)")
            }else{
                self.searchFollowedEntry(followedList)
               
            }
        }
    }
    
    private func searchFollowedEntry(_ list: [String]){
        firebaseService.fetchEntriesByList(list) { (entryStruct, error) in
            if let error = error{
                print("fetching user's followed entries fail \(error.localizedDescription)")
            }
           
            let entriesArray = entryStruct.compactMap({ $0 })
            self.entries?(entriesArray)
            
            
        }
    }
    
    func searchFavoriteCommentList(){
        firebaseService.fetchUserFavoriteList { (favoriteList, error) in
            if let error = error{
                print("fetching followed entry list fail \(error.localizedDescription)")
            }else{
                self.searchFavoriteComment(favoriteList)
               
            }
        }
        
    }
    
    private func searchFavoriteComment(_ list: [UserFavoriteStruct]){

        firebaseService.fetchCommentsByList(list) { (commentStruct, error) in
            if let error = error{
                print("fetching favorite comment list fail \(error.localizedDescription)")
            }else{
                self.comments!(commentStruct)
            }
        
        }
     
    }
    
    func callCommentView(row:Int,entry:EntryStruct){
        let commentNavVC = CommentNavController()
        commentNavVC.modalPresentationStyle = .fullScreen
        commentNavVC.entry = entry
        IdSingleton.shared.entryID = entry.documentID
        parent?.presentToRight(commentNavVC)
        
        
    }
    
    
    
}
