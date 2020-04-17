//
//  CollectionView.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 15/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import UIKit

//MARK:- CollectiomViewDelegate Conformance

extension ChatLogViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        //Number of cells
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return messages.count
        }
        
        //MARK:- Cell Setup
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            var cellToBeReturned = UICollectionViewCell()
            
            let message = messages[indexPath.item]
            
            if message.text == nil {
                if message.audioUrl == nil {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath) as! ChatLogImageCollectionViewCell
                self.setupImageCell(cell: cell, message: message)
                cellToBeReturned = cell
                }
                else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "audiocell", for: indexPath) as! ChatLogAudioCollectionViewCell
                    print("Audio cell incoming")
                    let audioTap = audioTapGesture.init(target: self, action: #selector(handleAudioTap))
                    audioTap.message = message
                    //cell.chatBubble.addGestureRecognizer(audioTap)
                    //cell.chatBubble.backgroundColor = .white
                    cell.addGestureRecognizer(audioTap)
                    cellToBeReturned = cell
                }
            } else {
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! chatLogCollectionViewCell
                    
                cell.messageTextView.text = message.text
                
                self.setupMessageCell(cell: cell, message: message)
                cell.bubbleWidthAnchor.constant = extimateFrameForText(text: message.text!).width + 32
                cellToBeReturned = cell
            }
            return cellToBeReturned
        }
    
    
    //MARK:- Set collectionView Height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 327
        if let text = messages[indexPath.item].text{
            height = extimateFrameForText(text: text).height + 20
        }
        if messages[indexPath.item].audioUrl != nil{
            height = 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    
    //MARK:- Height constraints for chat bubble
    private func extimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 327, height: 1000)
        
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
       }
    
    
    //MARK:- IDK
      override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
          collectionView.collectionViewLayout.invalidateLayout()
      }
}
