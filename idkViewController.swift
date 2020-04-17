//
//  idkViewController.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 16/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class idkViewController: UIViewController {

    var sp = [SponsorDataII]()
    override func viewDidLoad() {
        
        firebaseNetworking.shared.getSponsorII { (bool, sponsors) in
            if bool == true{
                print(sponsors[0].logoUrl)
            }
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
