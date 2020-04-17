//
//  Animations.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 15/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import UIKit


extension ChatLogViewController {
    
    func curveAnimation(button: UIButton, animationOptions: UIView.AnimationOptions, x: CGFloat, bool : Bool) {
        UIView.animate(withDuration: 0.01, delay: 0, options: animationOptions, animations: {
            self.sendButton.alpha = bool ? 0 : 1
            self.textfieldRightConstraint.isActive = !bool
            self.sendButton.isHidden = bool
            button.alpha = CGFloat(bool ? 1: 0)
        button.transform = CGAffineTransform.identity.translatedBy(x: x, y: 0)
        }, completion: nil)
    }
    
    @objc func handleImageTap(tapGesture: UITapGestureRecognizer){
        if let imageView = tapGesture.view as? UIImageView{
            self.performZoom(startingImageView: imageView)
        }
    }
    
    @objc func handleAudioTap(tapGesture: MyTapGesture){
            print("AudioTapped")
            if let message = tapGesture.message{
           self.playAudio(message: message)
             //   self.handlePlay(message: message)
            }
    }
    
    @objc func handleVideoTap(recognizer: MyTapGesture){
        if let imageView = recognizer.view as? UIImageView{
            self.performZoom(startingImageView: imageView)
            if let message = recognizer.message{
            self.handlePlay(message: message)
            }
        }
    }
    
    func performZoom(startingImageView : UIImageView){
        self.startingImageView = startingImageView
        startingImageFrame = startingImageView.globalFrame
        let zoomingImageView = UIImageView(frame: self.startingImageFrame ?? CGRect())
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomout)))
        
        var aspectRatio : CGFloat = 1
        
        backgroundView = UIView(frame: view.frame )
        backgroundView?.backgroundColor = .systemBackground
        backgroundView?.alpha = 0
        view.addSubview(backgroundView!)
        view.addSubview(zoomingImageView)
        if let image = startingImageView.image {
            aspectRatio = image.size.width / image.size.height
        }
        let width = view.frame.width
        let center = view.center
        let height = width / aspectRatio
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            zoomingImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            zoomingImageView.center = center
            self.backgroundView?.alpha = 1
        }){ (completed : Bool) in
            self.startingImageView?.isHidden = true
        }
    }
    
    @objc func zoomout(tapGesture: UITapGestureRecognizer){
        print("zoom  out")
        if  let zoomOutImageView = tapGesture.view{
            
            UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 1, initialSpringVelocity: 1 ,options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingImageFrame!
                self.backgroundView?.alpha = 0
            }) { (completed : Bool) in
                self.playerLayer?.removeFromSuperlayer()
                self.player?.pause()
                zoomOutImageView.removeFromSuperview()
                self.backgroundView?.removeFromSuperview()
                self.startingImageView?.isHidden = false
            }
        }
        
    }

    
}
