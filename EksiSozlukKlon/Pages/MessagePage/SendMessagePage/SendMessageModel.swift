//
//  SendMessagesModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 19.04.2021.
//

import Foundation
import Firebase

class SendMessageModel:NSObject{
    let firebaseService = FirebaseService()
    var documentRef:DocumentReference?
    var messageCointainer:(([Message])->())?
    var didChatBefore:Bool?
    
    
    var contactedUser:BasicUserStruct?{
        didSet{
            fetchMessages()
        }
    }
    
    
    
    override init() {
        super.init()
    }
    
    
    func fetchMessages(_ text:String?=nil){
        
        guard let contactedUserID =  contactedUser?.userId else {return}
      
        firebaseService.loadChat(contactedUserID: contactedUserID) { [self] (chats, error) in
            if let error = error {
                print("Chats loading error \(error.localizedDescription)")
                didChatBefore = nil
            }else{
                
                guard chats.first != nil else { didChatBefore = false; return }
                guard let user = firebaseService.user?.uid else {return}
                didChatBefore = true
                documentRef = chats.first?.docRef
                
                
                chats.first?.owners.forEach({
                    if $0["owner"] as? String == user{
                        getChatMessages()
                        if let messageText = text{
                            sendMessages(messageText)
                        }
                        return
                    }
                })
                
            }
            
        }
        
    }
    private func getChatMessages(){
        firebaseService.getAllMessages(docRef: documentRef!) { (messages, error) in
            if let error = error{
                print("fetching messages error \(error.localizedDescription)")
            }else{
                self.messageCointainer?(messages)
            }
        }
    }
    
    private func createNewChat(_ text:String){
        
        firebaseService.createNewChat(contactedUser: contactedUser!, firstMessage: text) { (error) in
            if let error = error {
                print("create new chat error \(error.localizedDescription)")
            }else{
                self.fetchMessages(text)
            }
        }
    }
    
    
    func sendMessages(_ text:String){
        guard let _ = didChatBefore else {return}
        if !didChatBefore! {
            createNewChat(text)
        }
        guard let _ =  contactedUser?.userId, let docRef = documentRef else {return}
        firebaseService.createNewMessage(content: text, chatRef: docRef) { (error) in
            if let error = error{
                print("sending message error: \(error.localizedDescription)")
            }else{
                self.getChatMessages()
            }
        }
    }
    
    
    
    
}
