//
//  FirebaseServices-MessageService.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.04.2021.
//

import Foundation
import Firebase


extension FirebaseService{
    
    func loadChat(handler:@escaping ([Chat],Error?)-> ()){
        var chats = [Chat]()
        //        check user
        guard let user = user else{handler(chats,nil); return}
        let query = db.collection(chatPath).whereField(users_ID, arrayContains:user.uid)
        
        //        check all chat which have userID
        
        listener = query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                handler(chats,error)
                
                return
            }else{
                guard let chatSnapshot = querySnapshot else { handler(chats,nil); return }
                //                is there any chat ?
                if chatSnapshot.documents.count > 0 {
                    
                    chats = []
                    for doc in chatSnapshot.documents {
                        if let chat = Chat(dictionary: doc.data(),ref:doc.reference, id: doc.documentID){
                            if chat.owners.map({ ($0["owner"] as! String)}).contains(where: {return $0 == user.uid}){
                                chats.append(chat)
                            }
                        }
                        
                    }
                }
                handler(chats,nil)
                return
            }
        }
    }
    
    func loadChat(contactedUserID:String ,handler:@escaping ([Chat],Error?)-> ()){
        
        //        we create empty chat array
        var chats = [Chat]()
        //        check user
        guard let user = user else{handler(chats,nil); return}
        let query = db.collection(chatPath).whereField(users_ID, arrayContains:user.uid)
        
        //        check all chat which have userID
        
        listener = query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                handler(chats,error)
                return
            }else{
                guard let chatSnapshot = querySnapshot else { handler(chats,nil); return }
                //                is there any chat ?
                if chatSnapshot.documents.count > 0 {
                        //                        if app send contacteduser this part will work
                        
                        chats = []
                        for doc in chatSnapshot.documents{
                            if let chat = Chat(dictionary: doc.data(),ref:doc.reference,id: doc.documentID){
                                chats.append(chat)
                                handler(chats,nil)
                                return
                            }
                        }
                }
                handler(chats,nil)
            }
        }
        
    }
    
    
    
    
    func createNewChat(contactedUser:BasicUserStruct,firstMessage:String, handler:@escaping (Error?)->()){
        
        guard let user = user else{handler(nil); return}
        let contractedUserNick = contactedUser.nick
        let date = Timestamp(date: Date())
        let chat = Chat(users: [user.uid,contactedUser.userId],  docRef: nil, usersNick:[(user.displayName ?? ""),contractedUserNick], date: date, owners: [
            ["owner" : user.uid,"since":Timestamp(date: Date()),first_message:firstMessage],
            ["owner" : contactedUser.userId,"since":Timestamp(date: Date()),first_message:firstMessage]
        ])
        let newChat = db.collection(chatPath).document()
        newChat.setData([users_ID : chat.users,
                         users_nick:chat.usersNick,
                         create_date:chat.date,
                         "owners":chat.owners
                         
        ]) { (error) in
            if let error = error{
                handler(error)
            }else{
                handler(nil)
            }
            
        }
        
    }
    
    
    
    
    
    func getAllMessages(docRef:DocumentReference,handler:@escaping ([Message],Error?)->()){
        var messages = [Message]()
        guard let user = user else {handler(messages,nil);return}
        db.runTransaction { transaction, _ in
            var chatDoc: DocumentSnapshot!
            do{
                chatDoc = try transaction.getDocument(docRef)
            }catch let error{
                handler(messages,error)
            }
            guard let owners = chatDoc.data()?["owners"] as? [[String:Any]] else {handler(messages,nil);return nil}
            var ownerSince : Timestamp?
            
            owners.forEach({
                if ($0["owner"] as? String) == user.uid{
                    ownerSince =   $0["since"] as? Timestamp
                }
            })
            guard let ownerSince = ownerSince else {handler(messages,nil);return nil}
            docRef.collection(messagesPath).order(by: "created", descending: false)
                .whereField("created", isGreaterThanOrEqualTo: ownerSince)
                .addSnapshotListener { (messageSnapshot, error) in
                    if let error = error {
                        handler(messages,error)
                        return
                    }else{
                        guard let messageSnapshot = messageSnapshot else {handler(messages,nil); return }
                        for doc in messageSnapshot.documents{
                            if let message = Message.init(dictionary: doc.data()){
                                messages.append(message)
                            }
                            
                        }
                        handler(messages,nil)
                        messages.removeAll()
                    }
                    
                }
            return nil
        } completion: { _, error in
            if let error = error{
                handler(messages, error)
            }
            
        }
        
    }
    
    
    
    
    func createNewMessage(content:String,chatRef:DocumentReference,handler:@escaping (Error?)->()){
        
        guard let user = user else {handler(nil);return}
        let id = UUID().uuidString
        var message:Message?
        
        db.runTransaction { transaction, _ in
            var chatDoc:DocumentSnapshot!
            do{
                chatDoc = try transaction.getDocument(chatRef)
                
            }catch let error{
                handler(error)
                return nil
            }
            
            guard var owners = chatDoc.data()?["owners"] as? [[String: Any]] else {return nil}
            if owners.count == 1 && (owners.first?["owner"] as? String) != user.uid{
                
                //  this is the first condition.The user who sending message was owner of the chat.
                //  But user deleted it before but receiver still owner of the chat.App only add sender as owner again.
                
                let newOwner = ["owner" : user.uid,"since":Timestamp(date: Date()),first_message:content] as [String : Any]
                owners.append(newOwner)
                transaction.updateData(["owners" : owners], forDocument: chatRef)
            }else if owners.count == 1 && (owners.first?["owner"] as? String) == user.uid {
                //  this is the second condition of message
                // the user who sending message currently is owner of the chat.
                //  Its receiver was owner too. Chat have been erased by him before ,so the receiver must been added as a owner again
                guard var users = chatDoc.data()?[users_ID] as? [String],
                      let index = users.firstIndex(of: user.uid)
                else{handler(nil); return nil}
                users.remove(at: index)
                
                let newOwner = ["owner" : users.first!,"since":Timestamp(date: Date()),first_message:content] as [String : Any]
                owners.append(newOwner)
                transaction.updateData(["owners" : owners], forDocument: chatRef)
            }
            
            message = Message(id: id, content:content, created: Timestamp(date: Date()), senderID: user.uid, senderName: user.displayName ?? "")
            chatRef.collection(messagesPath).addDocument(data: message!.dictionary) { (error) in
                if let error = error{
                    handler(error)
                    return
                }
            }
            
            handler(nil)
            return nil
        } completion: { _, error in
            if let error = error{
                handler(error)
            }
        }
    }
    
    
    
    func deleteChat(chatID:String,handler:@escaping (Error?)->()){
        //       when a chat is created there will be two owner.
        //       If one of them delete chat, app delete user from owner part.
        //       if other user delete it, it will completely been earesed
        
        guard let user = user else {handler(nil);return}
        db.runTransaction { [self] transaction, _ in
            let chatRef = db.collection(chatPath).document(chatID)
            var chatDoc:DocumentSnapshot!
            do{
                chatDoc = try transaction.getDocument(chatRef)
                
            }catch let error{
                handler(error)
                return nil
            }
            
            guard var owners = chatDoc.data()?["owners"] as? [[String: Any]] else {return nil}
            
            if owners.count == 2{
                //                Owners array have two userID .We delete only current userID from there. Other user can see messages but this user cannot see any more
                for (index,owner) in owners.enumerated(){
                    if (owner["owner"] as? String) == user.uid{
                        owners.remove(at: index)
                        transaction.updateData(["owners":owners], forDocument: chatRef)
                    }
                }
            }else{
                //                already other user delete chat and with this part all chat and messages will been erased
                deleteAllMessagesAndChat(chatRef){ error in
                    if let error = error{
                        handler(error)
                    }
                }
            }
            return nil
        } completion: { _, error in
            if let error = error{
                handler(error)
            }else{
                handler(nil)
            }
        }
    }
    
    
    
    func deleteAllMessagesAndChat(_ ref:DocumentReference,handler:@escaping (Error?)->()){
        
        let messageRef = ref.collection(messagesPath)
        messageRef.limit(to: 50).getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else{
                handler(error)
                return
            }
            
            guard querySnapshot.count>0 else {
                ref.delete { error in
                    if let error = error{
                        handler(error)
                    }
                }
                handler(nil)
                return }
            let batch = messageRef.firestore.batch()
            
            querySnapshot.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit { (error) in
                if let error = error {
                    handler(error)
                }else{
                    self.deleteAllMessagesAndChat(ref,handler : handler)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
}






