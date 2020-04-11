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
    
    
    var chatsViewController : ChatsViewController?

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
                user.name = (dictionary["name"] as! String)
                user.phone = (dictionary["phone"] as! String)
                user.profileImageUrl = (dictionary["profileImageUrl"] as! String)
                user.id = snapshot.key
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
        var outputCell = UITableViewCell()
        if  let cell =  newContactsTableView.dequeueReusableCell(withIdentifier: "newchatcell") as? NewChatTableViewCell {
        let user = users[indexPath.row]
        
        cell.profileImageView .image = #imageLiteral(resourceName: "Example")
       // cell?.imageView?.layer.cornerRadius = 25
        cell.nameLabel.text = user.name
        cell.statusLabel.text = user.phone
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            }
            outputCell = cell
        }
        return outputCell
       }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //unhighlight cell
        tableView.deselectRow(at: indexPath, animated: true)
        
        //perform segue
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(identifier: "ChatLogViewController") as? ChatLogViewController
        
        let user = users[indexPath.row]
        
        vc!.user = user
        
        
        let presenController : UINavigationController = self.presentingViewController as! UINavigationController

        self.dismiss(animated: false, completion: {
            presenController.pushViewController(vc!, animated: true)
        })

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
}


