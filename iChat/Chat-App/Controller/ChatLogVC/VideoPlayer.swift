//
//  VideoPlayer.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 15/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import AVFoundation

extension ChatLogViewController {
    //MARK:- Play Video
    func handlePlay(message: Message?){
            if let videoUrl = message?.videoUrl, let url = URL(string: videoUrl){
              player = AVPlayer(url: url)
                playerLayer = AVPlayerLayer(player: player)
              playerLayer!.frame = view.bounds
                  view.layer.addSublayer(playerLayer!)
              player!.play()
                print("playing")
            }
        }
}
