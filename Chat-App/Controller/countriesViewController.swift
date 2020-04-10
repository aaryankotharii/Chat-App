//
//  countriesViewController.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 11/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class countriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    

    @IBOutlet var tableView: UITableView!
    
    var mainViewController:PhoneAuthViewController?

    override func viewDidLoad() {
        let search = UISearchController(searchResultsController: nil)           // Declare the searchController
           self.navigationItem.searchController = search
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contries.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let country = contries[indexPath.row]
        
        cell?.textLabel?.text = (country["emoji"])! + " " + (country["name"] ?? "lol")
        
        cell?.detailTextLabel?.text = "+" + (country["code"])!
        
        return cell!
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = contries[indexPath.row]
        mainViewController?.countryName = country["name"] ?? "aaa"
        mainViewController?.countryCode = country["code"] ?? "aaa"
        mainViewController?.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
