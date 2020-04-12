//
//  ChatLogImageCollectionViewCell.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 12/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class ChatLogImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var bubbleLeftAnchor: NSLayoutConstraint!
    
    
    @IBOutlet var bubbleRightAnchor: NSLayoutConstraint!
    
    @IBOutlet var chatBubble: UIView!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var bubbleWidthAnchor: NSLayoutConstraint!
}
