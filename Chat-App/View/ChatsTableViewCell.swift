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
            self.lastMessageLabel.text = message?.text ?? "📸 Photo"
            if let seconds = message?.timestamp?.doubleValue {
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "hh:mm"
                
                self.timeLabel.text = dateFormatter.string(from: timestampDate as Date)
                
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
