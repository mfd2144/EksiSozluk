//
//  FirebaseService.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 1.04.2021.
//

import UIKit
import Firebase

protocol FireBaseCellDelegate {
    func decideToFavoriteImage(_ fill:Bool)
    func decideToLikeImage(_ fill:Bool)
    func listenSingleComment(_comment:CommentStruct)
    
}

protocol FireBaseEntryDelegate {
    func decideToFollowCondition(_ fill:Bool)
    func decideToEntryLikeCondition(_ fill:Bool)
}



class FirebaseService:NSObject{
    
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    lazy var userCollection = db.collection("User")
    lazy var entryCollection = db.collection("Entry")
    var listener :ListenerRegistration?
    var continuesListener:ListenerRegistration?
    var authStatus :((Status)->())?
    lazy var favoriteArray = [FavoriteStruct]()
    lazy var commentLikeArray = [LikeStruct]()
    lazy var followArray = [FollowerStruct]()
    lazy var entryLikesArray = [LikeStruct]()
    var lastCalledSnaphot :QueryDocumentSnapshot?
    lazy var mostFollowed = [MostLikedStruct] ()
  
    var userDocID:String?{
        get{
            return AppSingleton.shared.userDocID
        }
    }
    
    
    //    delegates
    var cellDelegate:FireBaseCellDelegate?
    var entryDelegate:FireBaseEntryDelegate?
    
    
    
    override init() {
        super.init()
        if user != nil {
            authStatus?(.login)
        }else{
            authStatus?(.logout)
        }
        
    }
    
    
    
    
 
}








