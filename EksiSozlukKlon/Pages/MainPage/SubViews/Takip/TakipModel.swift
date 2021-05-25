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
    var entriesContainer:(([EntryStruct])->())?
    var commentsContainer:(([CommentStruct])->())?
    var emptyCommentList = [String]()
    
    override init() {
        super.init()
        selectedIndex = { [self] selectedIndex in
            selectedIndex == 0 ? searchLikedEntryList() : searchFavoriteCommentList()
        }
        
    }
    
    
    func searchLikedEntryList(){
        firebaseService.fetchUserDemandedList { (followedList, error) in
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
            self.entriesContainer?(entriesArray)

            
            
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
        firebaseService.fetchCommentsByList(list) { (favoriteComments, error) in
            if let error = error{
                print("fetching favorite comment list fail \(error.localizedDescription)")
            }

                var comments = [CommentStruct]()

            for (index,comment) in  favoriteComments.enumerated(){
                if comment.commentText == ""{
                    self.emptyCommentList.append(comment.commentID)
                  
                }else{
                    comments.append(comment)
                }
                if index == favoriteComments.count-1{
                    self.commentsContainer?(comments)
                }
            }
            
            
            
            
               
        }
     
    }
    
    func callEntryView(row:Int,entry:EntryStruct){
        let commentNavVC = CommentNavController()
        commentNavVC.modalPresentationStyle = .fullScreen
        commentNavVC.entry = entry
        AppSingleton.shared.selectedView = Collections.takip
        parent?.presentToRight(commentNavVC)
        
        
    }
    
    func clearEmptyComments(){
        if !emptyCommentList.isEmpty{
            print("ssss")
        }
    }
    
    
}
