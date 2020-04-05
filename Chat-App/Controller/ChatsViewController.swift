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

class ChatsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        // Do any additional setup after loading the view.
        fetchData()
        observeMessages()
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
            print(snapshot)
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
}
