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
    }
    
    func fetchData(){
        if let uid = Auth.auth().currentUser?.uid{
            Database.database().reference().child("users").child(uid).observe(.value) { (snapshot) in
                print(snapshot)
            }
        }
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
