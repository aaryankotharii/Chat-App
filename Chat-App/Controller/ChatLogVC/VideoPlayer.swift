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
    
    //MARK:- Play Audio
    func handleAudio(message: Message?){
        
        if let audioUrl = message?.audioUrl{
            
            self.downloadAndSaveAudioFile(audioUrl){result in
                
                let path = URL(string: result)
                print("path is ",path)
                print("playing")
                do{
                    self.audioPlayer = try AVAudioPlayer(contentsOf: path!)
                    self.audioPlayer.play()
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
        }
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
