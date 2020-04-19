//
//  DatabaseManager.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 15/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

extension ChatLogViewController{
    
    //MARK:- Fetch Messages from DataBase
    func observeMessages(){
     guard let uid = Auth.auth().currentUser?.uid else {return}
     
     let userMessagesref = Database.database().reference().child("user-messages").child(uid)
     
     userMessagesref.observe(.childAdded, with: { (snapshot) in
        
         let messageId = snapshot.key
         
         let messagesRef = Database.database().reference().child("messages").child(messageId)
        
         messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
        guard let dictionary = snapshot.value as?[String:AnyObject] else { return }
             
            
            //MARK:- Create Message
             let message = Message()
             if let text = dictionary["text"]{ message.text = (text as! String) }
             message.fromId = (dictionary["fromId"] as! String)
             message.toId = (dictionary["toId"] as! String)
             message.timestamp = (dictionary["timestamp"] as! Int)
             if let imageUrl = dictionary["imageUrl"] { message.imageUrl = (imageUrl as! String) }
             if let videoUrl = dictionary["videoUrl"]{  message.videoUrl = (videoUrl as! String) }
             if let audioUrl = dictionary["audioUrl"]{ message.audioUrl = (audioUrl as! String)}
             
             if message.chatPatnerId() == self.user?.id {
                self.messages.append(message)
                 DispatchQueue.main.async {
                     self.collectionView.reloadData()
                     
                     //MARK:- Scroll collectionView To bottom
                     let indexPath = IndexPath(item: self.messages.count-1, section: 0)
                     self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    
    //MARK:- Send Message to firebase
    func sendData(){
        let ref = Database.database().reference().child("messages")
               
        let childRef = ref.childByAutoId()
               
        let toId = user!.id!
        
        let fromId = Auth.auth().currentUser!.uid
        
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        
        let values = ["text":chatTextField.text!, "toId":toId, "fromId":fromId,"timestamp":timeStamp] as [String : Any]
               
        childRef.updateChildValues(values) { (error, ref) in
            
            if let error = error{
                
                print(error.localizedDescription)
                
            }else{
                
                self.chatTextField.text = nil
                
                self.sendButton.isHidden = true
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
                
                let messageId = childRef.key!
                
                userMessagesRef.updateChildValues([messageId:"a"])
                
                let recipientUserMessagesReference = Database.database().reference().child("user-messages").child(toId)
                
                recipientUserMessagesReference.updateChildValues([messageId:"a"])
            }
        }
    }
}
