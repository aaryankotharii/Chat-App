//
//  ChatsViewController.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 04/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatsViewController: UIViewController{
    
    //MARK: - variables
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    var timer : Timer?


    //MARK: - Outlets
    @IBOutlet weak var chatsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.defaultPhoneLogin(number: "9898989898", otp:"123456")
        navigationController?.navigationBar.prefersLargeTitles = true
        observeUserMessages()
    }
    
    func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            
            let messagesReference = Database.database().reference().child("messages").child(messageId)
            
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
            if let dictionary = snapshot.value as? [String:AnyObject]{
                
                let message = Message()
                
                if let text = dictionary["text"]{ message.text = text  as? String }
                message.fromId = (dictionary["fromId"] as! String)
                message.toId = (dictionary["toId"] as! String)
                message.timestamp = (dictionary["timestamp"] as! Int)
                if let imageUrl = dictionary["imageUrl"] { message.imageUrl = (imageUrl as! String) }
                if let videoUrl = dictionary["videoUrl"]{  message.videoUrl = (videoUrl as! String) }
                if let audioUrl = dictionary["audioUrl"]{ message.audioUrl = (audioUrl as! String)}
                
                                              
                 if let chatPatnerId = message.chatPatnerId() {
                    
                     self.messagesDictionary[chatPatnerId]  = message
                    
                     self.messages = Array(self.messagesDictionary.values)
                    
                    //MARK:- Sort messages Array
                     self.messages.sort { (message1, message2) -> Bool in
                         var bool = false
                         if let time1 = message1.timestamp, let time2 = message2.timestamp {
                         bool = time1 > time2
                         }
                         return bool
                     }
                 }
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                 }
            }, withCancel: nil)
        }, withCancel: nil)
    }
        
        @objc func handleReloadTable(){
            DispatchQueue.main.async {
                self.chatsTableView.reloadData()
            }
        }
        
        //MARK: - Logout functions
        @IBAction func editClicked(_ sender: Any) {
            signOut()
        }
        
        func toChatLogVC(){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "ChatLogViewController") as? ChatLogViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    
        //MARK: - Signout function
        func signOut() {
            let firebaseAuth = Auth.auth()
            do {
                // Set initial user default for login as false
                UserDefaults.standard.set(false, forKey: "login")
                try firebaseAuth.signOut()
                debugLog(message: "SignOut successful")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! UINavigationController
                self.present(controller, animated: true, completion: nil)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }

//MARK:- TableView Delegate functions

extension ChatsViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = chatsTableView.dequeueReusableCell(withIdentifier: "chatcell") as? ChatsTableViewCell
        
        let message = messages[indexPath.row]
        
        cell?.message = message
        
        return cell!
     }
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //unhighlight cell
        tableView.deselectRow(at: indexPath, animated: true)
        
        let message = messages[indexPath.row]

        guard let chatPatnerId = message.chatPatnerId() else { return }
        
        let ref = Database.database().reference().child("users").child(chatPatnerId)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String:AnyObject]  else { return}
            
            let user = User()
            
            user.name = (dictionary["name"] as! String)
            user.phone = (dictionary["phone"] as! String)
            user.profileImageUrl = (dictionary["profileImageUrl"] as! String)
            user.id = chatPatnerId
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(identifier: "ChatLogViewController") as? ChatLogViewController
            
            vc!.user = user
            
            self.navigationController?.pushViewController(vc!, animated: true)

        }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.5
    }
}
