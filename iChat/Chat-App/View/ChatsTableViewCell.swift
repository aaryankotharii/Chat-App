//
//  ChatsTableViewCell.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 06/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth



class ChatsTableViewCell: UITableViewCell {
    
    var message : Message? {
        didSet{
            setupNameAndProfileImage ()
            if message?.videoUrl != nil{
                self.lastMessageLabel.text = "📹 Video"
            }else if message?.imageUrl != nil{
                self.lastMessageLabel.text = "📸 Photo"
            }else if message?.audioUrl != nil {
                 self.lastMessageLabel.text = "🎤 Audio"
        }else{
                self.lastMessageLabel.text =  message?.text
            }
            if let seconds = message?.timestamp?.doubleValue {
                let time = seconds.timeStringConverter
                self.timeLabel.text = time
            }
        }
    }
    
    
    private func setupNameAndProfileImage(){
        if let id = message?.chatPatnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    self.nameLabel.text = dictionary["name"] as? String
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profilePicture.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
    }
    
    
    //MARK:- Cell Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
