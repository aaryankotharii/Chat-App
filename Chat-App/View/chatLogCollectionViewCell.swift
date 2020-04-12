//
//  chatLogCollectionViewCell.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 06/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class chatLogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var bubbleRightAnchor: NSLayoutConstraint!
    
    @IBOutlet var bubbleLeftAnchor: NSLayoutConstraint!
    
    @IBOutlet var chatBubble: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var bubbleWidthAnchor: NSLayoutConstraint!
    
    }
