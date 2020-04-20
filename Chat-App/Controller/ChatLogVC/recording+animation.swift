//
//  recording+animation.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 17/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import AVFoundation

extension ChatLogViewController : AVAudioRecorderDelegate {


            func onStart() {
                print("Start")
                onEnd()
                UIView.animate(withDuration: 0.25, animations: {
                    self.start_initial()
                    }) { (Bool) in
                        self.start_completeion()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
                    UIView.animate(withDuration: 0.4, animations: {
                        self.cameraButton.alpha = 0
                        self.timeLabel.alpha = 1
                    }){ (Bool) in
                        self.setTimer()
                        self.startRecording()
                        self.micButton.alpha = 0.2
                    }
                }
            }
        
            
            func onEnd() {
                print("END")
                resetAnimations()
                resetTimer()
                finishRecording(success: true)
            }
            

            func resetAnimations(){
                redMic.alpha = 0
                redMic.layer.removeAllAnimations()
                micLeftAnchor.constant = 380
                chatTextField.transform = .identity
                self.plusButton.transform = .identity
                self.cameraButton.alpha = 1
                self.micButton.alpha = 1
                micButton.isHighlighted = false
                 stc.transform = CGAffineTransform(translationX: 190, y: 0)
                stc.isHidden = true
        }
            
    
    //MARK:- Timer functions
    func setTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateDuration), userInfo: nil, repeats: true)
    }

    @objc private func updateDuration() {
        duration += 1
        timeLabel.text = duration.timeStringFormatter
       }
    
    func resetTimer(){
        duration = 0.0
        timeLabel.alpha = 0
        timeLabel.text = "0:00"
        timer?.invalidate()
        print("Timer reset")
    }
    
    
    func start_initial(){
        //MARK:- move textfield and +button out
        self.chatTextField.transform = CGAffineTransform(translationX: -400, y: 0).concatenating(CGAffineTransform(scaleX: 0.99, y: 0.99))
        self.plusButton.transform = CGAffineTransform(translationX: -400, y: 0).concatenating(CGAffineTransform(scaleX: 0.99, y: 0.99))
        
        //MARK:- mic before effects
        self.redMic.image = #imageLiteral(resourceName: "grey mic")
        self.redMic.alpha = 1
        self.micLeftAnchor.constant = 12
        self.view.layoutIfNeeded()
        
        stc.isHidden = false
        stc.transform = .identity
    }
    
    
    func start_completeion(){
        //MARK:- animate mic alpha
        redMic.isHidden = false
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 0
        alphaAnimation.toValue = 1.0
        alphaAnimation.repeatCount = .infinity
        alphaAnimation.autoreverses = true
        alphaAnimation.duration = 0.4
        alphaAnimation.speed = 0.4
        redMic.layer.add(alphaAnimation, forKey: "micAlphaAnimationName")
        
        //MARK:- set red mic image
        self.redMic.image = #imageLiteral(resourceName: "red mic")
    }
    
    func startRecording() {
        print("recording started")
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            print("recording now")
        } catch {
            finishRecording(success: false)
            print("recording failed")
            print(error.localizedDescription)
        }
    }
    
    func finishRecording(success: Bool) {
        if audioRecorder != nil{
        print("finished")
        audioRecorder.stop()
        audioRecorder = nil
        uploadAudio()
        }
    }
    
    func uploadAudio(){
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        self.uploadToFirebaseStorageUsingAudio(path)
    }
    
    
    func getDocumentsDirectory() -> URL {
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         return paths[0]
     }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
//    func playAudio(message: Message){
//        print("message is",message)
//        if let audioUrl = message.audioUrl, let url = URL(string: audioUrl){
//            print("Url is",audioUrl)
//            print("playing")
//            
//            audioPlayer =  AVPlayer(url: url)
//            audioPlayer.play()
//        }
//    }
    
}
