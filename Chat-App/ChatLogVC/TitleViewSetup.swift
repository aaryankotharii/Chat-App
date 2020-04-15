//
//  TitleViewSetup.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 15/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import UIKit

extension ChatLogViewController {
    
    //MARK:- Adding Custom Title View
    func addNavBarImage(user: User){
        
        let titleview = UIView()
        titleview.frame = CGRect(x: 0, y: 0, width: 300, height: 36)
        
        //Setup Profile Picture
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .black
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 18
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl
        { profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl) }
        
        titleview.addSubview(profileImageView)
    
        //ProfileImageView Constraints
        profileImageView.centerYAnchor.constraint(equalTo: titleview.centerYAnchor, constant: 0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        profileImageView.trailingAnchor.constraint(equalTo: titleview.trailingAnchor, constant: -70).isActive = true
        
        //Setup NameLabel
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        let name = user.name ?? ""
        nameLabel.text = name
        nameLabel.font = UIFont(name: "SFProDisplay-Medium", size: 16.4)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        titleview.addSubview(nameLabel)

        //nameLabel Constraints
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 9).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: titleview.centerYAnchor, constant: 0).isActive = true

        //Add TitleView + tapGesture
        self.navigationItem.titleView = titleview
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapNavBar))
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
    }
    
    //MARK:- NavBar Tap function
    @objc func didTapNavBar() {
        print("user did tap navigation bar")
    }
}
