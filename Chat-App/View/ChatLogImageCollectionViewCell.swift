//
//  ChatLogImageCollectionViewCell.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 12/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import AVFoundation

class ChatLogImageCollectionViewCell: UICollectionViewCell {
    
    var message : Message?
    
    @IBOutlet var bubbleLeftAnchor: NSLayoutConstraint!
    
    
    @IBOutlet var bubbleRightAnchor: NSLayoutConstraint!
    
    @IBOutlet var chatBubble: UIView!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var playButton: UIImageView!
    
    @IBOutlet var bubbleWidthAnchor: NSLayoutConstraint!
    
    func handlePlay(view: UIView){
        if let videoUrl = message?.videoUrl, let url = URL(string: videoUrl){
           let player = AVPlayer(url: url)
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = view.bounds
            view.layer.addSublayer(playerLayer)
            player.play()
            print("playing")
        }
    }
}
