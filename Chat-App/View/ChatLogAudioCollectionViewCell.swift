//
//  ChatLogAudioCollectionViewCell.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 17/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import AVFoundation

class ChatLogAudioCollectionViewCell: UICollectionViewCell {
    
        
    /// - This cell if for Audio Messages

    @IBOutlet var bubbleLeftAnchor: NSLayoutConstraint!
    @IBOutlet var bubbleRightAnchor: NSLayoutConstraint!
    @IBOutlet var bubbleWidthAnchor: NSLayoutConstraint!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var chatBubble: UIView!
    @IBOutlet var profilePicture: UIImageView!
    
    @IBOutlet var silder: UISlider!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        silder.setThumbImage(#imageLiteral(resourceName: "Oval"), for: .normal)
        // Initialization code
    }
    
    
    @IBAction func silded(_ sender: UISlider) {
        print(sender.value)
    }
    
    
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        print("celll tapped audio idk bruh ")
    }
    
    var message : Message?

    func handleAudio(){
        if let audioUrl = message?.audioUrl, let url = URL(string: audioUrl){
           let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = chatBubble.bounds
            chatBubble.layer.addSublayer(playerLayer)
            player.play()
            print("playing Audio (cell function)")
        }
    }
}
