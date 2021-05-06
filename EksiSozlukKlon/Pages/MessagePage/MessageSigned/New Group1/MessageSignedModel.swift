//
//  MessageSignedModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 21.04.2021.
//

import UIKit


class MessageSignedModel:NSObject{
    let firebaseService = FirebaseService()
    var chatsFetcher:(([Chat])->())?
    
    override init() {
        super.init()
    }
    
    func fetchChats(){
        firebaseService.loadChat { (chats, error) in
            if let error = error {
                print("Chats loading error \(error.localizedDescription)")
            }else{
                self.chatsFetcher?(chats)
            }
        }
        
    }
    
    func openMessagePage(chat:Chat)->UIViewController?{

        guard let userID = firebaseService.user?.uid,
              let userName = firebaseService.user?.displayName,
              let index = chat.users.firstIndex(of: userID),
            let nickIndex = chat.usersNick.firstIndex(of: userName)
        
        else {
            return nil
        }
     
        //        chat is let so create new variable
        var _chat = chat
        _chat.users.remove(at: index)
        _chat.usersNick.remove(at: nickIndex)
        
        let contactedBasicUser = BasicUserStruct(nick: _chat.usersNick.first!, userID:_chat.users.first! )
        let messageVC = SendMessageViewController()
        messageVC.contactedUser = contactedBasicUser
        return messageVC
    }
    
    func deleteChatWithSubCompanents(id:String) {
        
            self.firebaseService.deleteChat(chatID: id) { error in
                if let error = error {
                    print("chat delete error \(error)")
                }
            }
    }
    
}
