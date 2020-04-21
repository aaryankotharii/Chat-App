//
//  ChatLogAudioCollectionViewCell.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 17/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

class ChatLogAudioCollectionViewCell: UICollectionViewCell {
    
        
    /// - This cell if for Audio Messages

    //MARK:- Outlets
    @IBOutlet var bubbleLeftAnchor: NSLayoutConstraint!
    @IBOutlet var bubbleRightAnchor: NSLayoutConstraint!
    @IBOutlet var bubbleWidthAnchor: NSLayoutConstraint!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var chatBubble: UIView!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var silder: UISlider!
    
    
    //MARK:- Variables
    var message : Message?
    
    var user : User?
    
   //audioPlayer
   var recordingSession : AVAudioSession!
   var audioRecorder : AVAudioRecorder!
   var audioPlayer : AVAudioPlayer!
    
   var displayLink = CADisplayLink()

    
    @IBAction func silded(_ sender: UISlider) {
       
    }
    
    func setupAudioCell(message: Message){
        if message.audioUrl != nil {
            imageView.isUserInteractionEnabled = true
            let tapped = audioTapGesture.init(target: self, action: #selector(handleAudioTap))
            displayLink = CADisplayLink(target: self, selector: #selector(self.updateSliderProgress))
        //                               self.displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
                       tapped.message = message
                       imageView.addGestureRecognizer(tapped)
                    
                }
        if message.fromId == getUID() {
            //MARK:- Green cell

            let ref = Database.database().reference().child("users").child(getUID())
            
            //Slider
            silder.setThumbImage(#imageLiteral(resourceName: "Oval"), for: .normal)
            silder.maximumTrackTintColor = UIColor(named: "left audio")
            silder.minimumTrackTintColor = UIColor(named: "left audio")
            
            
            //profile picture
            ref.observe(.value) { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                       self.profilePicture.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
            }
            
            
            //chat bubble
           chatBubble.backgroundColor = UIColor(named: "tochatcolor")
           bubbleLeftAnchor.isActive = false
           bubbleRightAnchor.isActive = true
                          
            
            }else {
            //MARK:- white cell
            
            
            //Slider
            silder.setThumbImage(#imageLiteral(resourceName: "left_oval"), for: .normal)
            silder.maximumTrackTintColor = UIColor(named: "left audio")
            silder.minimumTrackTintColor = UIColor(named: "left audio")

            
            //profile picture
            if let profileImageUrl = user!.profileImageUrl
            { self.profilePicture.loadImageUsingCacheWithUrlString(urlString: profileImageUrl) }

            
            //chat bubble
            chatBubble.backgroundColor = UIColor(named: "fromchatcolor")
            bubbleRightAnchor.isActive = false
            bubbleLeftAnchor.isActive = true
            
            }
    }
    
    
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        print("celll tapped audio idk bruh ")
    }
    
    @objc func handleAudioTap(tapGesture: audioTapGesture){
             print("AudioTapped")
             if let message = tapGesture.message{
                 self.handleAudio(message: message)
             }
     }
    
    
        //MARK:- Play Audio
        func handleAudio(message: Message?){
            
            if let audioUrl = message?.audioUrl{
                
                self.downloadAndSaveAudioFile(audioUrl){result in
                    
                    let path = URL(string: result)
                    do{
                        self.audioPlayer = try AVAudioPlayer(contentsOf: path!)
                        self.audioPlayer.play()
                        DispatchQueue.main.async {
                            self.imageView.image = #imageLiteral(resourceName: "Combined Shape")
                        }
                        self.displayLink = CADisplayLink(target: self, selector: #selector(self.updateSliderProgress))
                        self.displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        @objc func updateSliderProgress(){
            var progress = audioPlayer.currentTime / audioPlayer.duration
            print(progress)
            if audioPlayer.isPlaying == false {
                displayLink.invalidate()
                imageView.image = #imageLiteral(resourceName: "playButton")
                progress = 0
            }
            silder.value = Float(progress)
    }
        

        
        func downloadAndSaveAudioFile(_ audioFile: String, completion: @escaping (String) -> ()) {
            
            //Create directory if not present
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentDirectory = paths.first! as NSString
            let soundDirPathString = documentDirectory.appendingPathComponent("Sounds")
            
            do {
                try FileManager.default.createDirectory(atPath: soundDirPathString, withIntermediateDirectories: true, attributes:nil)
                print("directory created at \(soundDirPathString)")
            } catch let error as NSError {
                print("error while creating dir : \(error.localizedDescription)");
            }
            
            if let audioUrl = URL(string: audioFile) {
                // create your document folder url
                let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first! as URL
                let documentsFolderUrl = documentsUrl.appendingPathComponent("Sounds")
                // your destination file url
                let destinationUrl = documentsFolderUrl.appendingPathComponent(audioUrl.lastPathComponent)
                
                print(destinationUrl,"destinationURl")
                // check if it exists before downloading it
                if FileManager().fileExists(atPath: destinationUrl.path) {
                    print("The file already exists at path")
                    completion(destinationUrl.absoluteString)
                } else {
                    //  if the file doesn't exist
                    //  just download the data from your url
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                        if let myAudioDataFromUrl = try? Data(contentsOf: audioUrl){
                            // after downloading your data you need to save it to your destination url
                            if (try? myAudioDataFromUrl.write(to: destinationUrl, options: [.atomic])) != nil {
                                print("file saved")
                                completion(destinationUrl.absoluteString)
                            } else {
                                print("error saving file")
                                completion("")
                            }
                        }
                    })
                }
            }
        }
    }

