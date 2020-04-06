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

class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
     var messages = [Message]()

    @IBOutlet weak var chatsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        // Do any additional setup after loading the view.
        fetchData()
        observeMessages()
        print(messages)
    }
    
    func fetchData(){
        if let uid = Auth.auth().currentUser?.uid{
            Database.database().reference().child("users").child(uid).observe(.value) { (snapshot) in
                print(snapshot)
            }
        }
    }
    
    func observeMessages(){
        let ref = Database.database().reference().child("messages")
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
            
            let message = Message()
                
            message.fromId = dictionary["fromId"] as! String
            message.text = dictionary["text"] as! String
            message.toId = dictionary["toId"] as! String
            message.timestamp = dictionary["timestamp"] as! Int
                
              //message.setValuesForKeys(dictionary)
                print(message.text)
                self.messages.append(message)
                self.chatsTableView.reloadData()
            }
            //print(snapshot)
        }, withCancel: nil)
    
    }
    
    @IBAction func editClicked(_ sender: Any) {
        toChatLogVC()
    }
    
    func toChatLogVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ChatLogViewController") as? ChatLogViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatsTableView.dequeueReusableCell(withIdentifier: "chatcell") as? ChatsTableViewCell
        
        let message = messages[indexPath.row]
        
        cell?.message = message
        
        return cell!
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.5
    }
}
