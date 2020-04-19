//
//  countriesViewController.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 11/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit



class countriesViewController: UIViewController, UISearchControllerDelegate {

    
 

    //MARK:- Outlets + Variables
    
    @IBOutlet var tableView: UITableView!
    
    var mainViewController:PhoneAuthViewController?  // to Send Data backwards
    
    let search = UISearchController(searchResultsController: nil)    // Declare the searchController
    
    var searchResults = [String:String]()  // Filter for searhc

    
    //MARK:- ViewDidLoad + initial Setup
    override func viewDidLoad() {
        self.navigationItem.searchController = search
        search.delegate = self
        super.viewDidLoad()
    }
}


//MARK:- CountriesVC TableView Delegate Methods
extension countriesViewController :  UITableViewDelegate, UITableViewDataSource {
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
        tableView.deselectRow(at: indexPath, animated: true)
        let country = contries[indexPath.row]
        mainViewController?.countryName = country["name"] ?? "aaa"
        mainViewController?.countryCode = country["code"] ?? "aaa"
        mainViewController?.tableView.reloadData()
        mainViewController?.countryCodeLabel.text = "+" +  (mainViewController!.countryCode)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
