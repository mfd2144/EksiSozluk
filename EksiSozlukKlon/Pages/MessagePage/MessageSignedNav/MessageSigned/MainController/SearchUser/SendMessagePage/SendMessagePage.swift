//
//  SendMessagePage.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 19.04.2021.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase


class SendMessageViewController:MessagesViewController,MessagesLayoutDelegate,MessagesDisplayDelegate,MessagesDataSource{

    var messages:[Message] = []
    let firebaseService = FirebaseService()
    let model = SendMessageModel()
    
    var currentUser:User?{
        get{
            return firebaseService.user
        }
    }
    
    var contactedUser:BasicUserStruct?{
        didSet{
            model.contactedUser = contactedUser
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.resetNewMessages()
        model.stopListener()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = contactedUser?.nick ?? "Chat"

        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .none
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        model.messageCointainer = { messages in
            DispatchQueue.main.async {
                self.messages = messages
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            }

        }
        
    }
    
    
    func currentSender() -> SenderType {
        return Sender(senderId: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        if messages.count == 0 {
                    return 0
                } else {
                    return messages.count
                }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
  
}

extension SendMessageViewController:InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        model.sendMessages(text)
        inputBar.inputTextView.text = ""
    }
    
    // MARK: - MessagesLayoutDelegate
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    // MARK: - MessagesDisplayDelegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue: .lightGray
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if message.sender.senderId == currentUser?.uid {
            avatarView.image = UIImage(named: "me")
//            SDWebImageManager.shared.loadImage(with: currentUser?.photoURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
//                avatarView.image = image
            
            
//            }
        } else {
            avatarView.image = UIImage(named: "you")
    
//            SDWebImageManager.shared.loadImage(with: URL(string: ), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
//                avatarView.image = image
//            }
        }
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)

    }
    
}


