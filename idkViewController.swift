////
////  idkViewController.swift
////  Chat-App
////
////  Created by Aaryan Kothari on 16/04/20.
////  Copyright © 2020 Aaryan Kothari. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//class idkViewController: UIViewController, AVAudioRecorderDelegate {
//    
//    @IBOutlet var recordButton: UIButton!
//    
//    var recordingSession : AVAudioSession!
//    
//    var audioRecorder : AVAudioRecorder!
//    
//    var audioPlayer : AVAudioPlayer!
//    
//
//    override func viewDidLoad() {
//        
//        
//        super.viewDidLoad()
//      
//        
//        //setting up session
//        recordingSession = AVAudioSession.sharedInstance()
//        
//        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
//            if hasPermission{
//                print("mic permission granted")
//            }
//        }
//    }
//    @IBAction func startRecording(_ sender: Any) {
//         if audioRecorder == nil {
//               startRecording()
//           } else {
//               finishRecording(success: true)
//           }
//    }
//    
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        if !flag {
//            finishRecording(success: false)
//        }
//    }
//    
//    func startRecording() {
//        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
//
//        let settings = [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//            AVSampleRateKey: 12000,
//            AVNumberOfChannelsKey: 1,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//        ]
//
//        do {
//            print("recording started")
//            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            audioRecorder.delegate = self
//            audioRecorder.record()
//
//            recordButton.setTitle("Tap to Stop", for: .normal)
//        } catch {
//            finishRecording(success: false)
//        }
//    }
//    func finishRecording(success: Bool) {
//        print("stopped")
//        audioRecorder.stop()
//        audioRecorder = nil
//
//        if success {
//            recordButton.setTitle("Tap to Re-record", for: .normal)
//        } else {
//            recordButton.setTitle("Tap to Record", for: .normal)
//            // recording failed :(
//        }
//    }
//    
//    @IBAction func play(_ sender: Any) {
//        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
//        print("playing")
//        do{
//            audioPlayer = try AVAudioPlayer(contentsOf: path)
//            audioPlayer.play()
//        }catch{
//            print(error.localizedDescription)
//        }
//    }
//    
//    
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//}
