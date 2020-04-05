//
//  NewChatsViewController.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 04/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewChatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var newContactsTableView: UITableView!
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNavBar()
        fetchUsers()
    }
    func setNavBar(){
        let searchBar = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func fetchUsers(){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                //user.setValuesForKeys(dictionary)
                user.name = dictionary["name"] as! String
                user.email = dictionary["email"] as! String
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.newContactsTableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  newContactsTableView.dequeueReusableCell(withIdentifier: "newchatcell") as? NewChatTableViewCell
        let user = users[indexPath.row]
        cell?.NameLabel.text = user.name
        cell?.statusLabel.text = user.email
        return cell!
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
}
