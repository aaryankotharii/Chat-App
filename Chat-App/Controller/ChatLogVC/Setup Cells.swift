//
//  Setup Cells.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 15/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

extension ChatLogViewController {
    
    //MARK:- Text Message Cell
     func setupMessageCell(cell : chatLogCollectionViewCell, message : Message){
         
         if message.fromId == Auth.auth().currentUser?.uid {
             cell.chatBubble.backgroundColor = UIColor(named: "tochatcolor")
             cell.bubbleLeftAnchor.isActive = false
             cell.bubbleRightAnchor.isActive = true
            cell.chatTipLeft.isHidden = true
            cell.chatTip.isHidden = false

                }else {
             cell.chatBubble.backgroundColor = UIColor(named: "fromchatcolor")
             cell.bubbleRightAnchor.isActive = false
             cell.bubbleLeftAnchor.isActive = true
            cell.chatTip.isHidden = true
            cell.chatTipLeft.isHidden = false

                }
     }
    
    
    //MARK:- Media Message Cell
     func setupImageCell(cell : ChatLogImageCollectionViewCell, message : Message){
        cell.message = message
        if let imageUrl = message.imageUrl {
            cell.imageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
            //MARK:- Video Cell
           if message.videoUrl != nil{
               let tapped = MyTapGesture.init(target: self, action: #selector(handleVideoTap))
               tapped.message = message
               cell.imageView.addGestureRecognizer(tapped)
            cell.playButton.isHidden = false
           }
            //MARK:- Photo Cell
           else {
               cell.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
            cell.playButton.isHidden = true
            }
        }
           if message.fromId == Auth.auth().currentUser?.uid {
                      //green Cell
               cell.chatBubble.backgroundColor = UIColor(named: "tochatcolor")
               cell.bubbleLeftAnchor.isActive = false
               cell.bubbleRightAnchor.isActive = true
                  }else {
                      //white cell
               cell.chatBubble.backgroundColor = UIColor(named: "fromchatcolor")
               cell.bubbleRightAnchor.isActive = false
               cell.bubbleLeftAnchor.isActive = true
                  }
       }
}

//MARK:- Video Tap Gesture (To pass variable)
class MyTapGesture: UITapGestureRecognizer {
    var message : Message?
}

//MARK:- Video Tap Gesture (To pass variable)
class audioTapGesture: UITapGestureRecognizer {
    var message : Message?
}
