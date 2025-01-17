//
//  ChatLogViewController.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 05/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import AVFoundation

class ChatLogViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK:- Outlets
    @IBOutlet var textfieldRightConstraint: NSLayoutConstraint!
    @IBOutlet var keyboardBottomAnchot: NSLayoutConstraint!
    @IBOutlet var keyBoardView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var tempView: UIView!
    @IBOutlet var micLeftAnchor: NSLayoutConstraint!
    @IBOutlet var redMic: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var stc: UIImageView!
    
    
    
      //MARK:- Variables
    
      //ImageView
      var startingImageFrame : CGRect?
      var backgroundView : UIView?
      var startingImageView : UIImageView?
      
      //VideoPlayer
      var playerLayer : AVPlayerLayer?
      var player : AVPlayer?
    
      //audioPlayer
      var recordingSession : AVAudioSession!
      var audioRecorder : AVAudioRecorder!
      var audioPlayer : AVAudioPlayer!
    
      //Timer
      var timer: Timer?
      var duration: CGFloat = 0
      
    
      var messages = [Message]()

      var user : User? {
            didSet{
                setNavBarTitle(user: user!)
                observeMessages()
            }
        }
    
    //TitleBar UI
    let profileImageView = UIImageView()
    

    //MARK:- Activity Indicator
    var activityIndicatorView : UIActivityIndicatorView{
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.translatesAutoresizingMaskIntoConstraints = true
        aiv.hidesWhenStopped = true
        aiv.startAnimating()
        return aiv
    }
    
    private func callNumber(phoneNumber:String) {

      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {

        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }


        

    //MARK:- ViewDidLoad + InitialSetup
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup(){
        
        //Title
        self.navigationItem.largeTitleDisplayMode = .never
        
        //keyboard dissmiss mode
        collectionView.keyboardDismissMode = .interactive

        //Button
        self.sendButton.isHidden = true
        
        //TextField
        addIndent(chatTextField)
        chatTextField.delegate = self
        chatTextField.layer.borderColor = UIColor(named: "border")?.cgColor
        chatTextField.layer.borderWidth = 0.5
        chatTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        //Collectionview
        collectionView.alwaysBounceVertical=true
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 7, right: 0)
        
        //setup recording ui
        stc.isHidden = true
        timeLabel.alpha = 0
        tempView.isHidden = true
        redMic.alpha = 0
        
        //setting up recording session
        recordingSession = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission{ print("mic permission granted") }
        }
        
        //setting keyboard observer
        NotificationCenter.default.addObserver(self,
              selector: #selector(self.keyboardNotification(notification:)),
              name: UIResponder.keyboardWillChangeFrameNotification,
              object: nil)
        
    }

        //MARK:- Button Action Outlets
        @IBAction func plusClicked(_ sender: Any) {
            self.createPLusActionSheet()
        }
        
        
        @IBAction func cameraClicked(_ sender: Any) {
            self.cameraTapped()
        }
        
        
        @IBAction func micClicked(_ sender: Any) {
            print("Mic clicked")
        }
    
    
    @IBAction func micLongPress(_ sender: UILongPressGestureRecognizer) {
            sender.minimumPressDuration = 0.5
            if sender.state == .began
            {
                print("recording began")
                onStart()
            }
            if sender.state == .ended {
                print("ended")
                //Send recording
                onEnd()
            }
            if sender.state == .changed{
                print("cancel audio")
                //trash animation
            }
    }
    
    @IBAction func touchOutmic(_ sender: Any) {
        print("touch out mic")
    }
    
    @IBAction func micSwipe(_ sender: UISwipeGestureRecognizer) {
        print("swipe")
    }
    
    @IBAction func sendClicked(_ sender: Any) {
           sendData()
        self.curveAnimation(button: self.cameraButton, animationOptions: .curveEaseIn, x: 0, bool: true)
        self.curveAnimation(button: self.micButton, animationOptions: .curveEaseIn, x: 0, bool: true)

        }
    
    @IBAction func phoneClicked(_ sender: Any) {
        print("phone clicked")
        callNumber(phoneNumber: (user?.phone!)!)
    }
    
    
        //MARK:- Chat TextField fucntions
        @objc func textFieldDidChange(_ textField: UITextField) {
            if sendButton.isHidden {
                self.textfieldRightConstraint.priority = UILayoutPriority(rawValue: 900)
                self.curveAnimation(button: self.cameraButton, animationOptions: .curveEaseOut, x: 50, bool: false)
                self.curveAnimation(button: self.micButton, animationOptions: .curveEaseOut,  x: 50, bool: false)
            }
            if chatTextField.text == ""{
                self.curveAnimation(button: self.cameraButton, animationOptions: .curveEaseIn, x: 0, bool: true)
                self.curveAnimation(button: self.micButton, animationOptions: .curveEaseIn, x: 0, bool: true)
            }
        }
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            sendData()
            self.curveAnimation(button: self.cameraButton, animationOptions: .curveEaseIn, x: 0, bool: true)
            self.curveAnimation(button: self.micButton, animationOptions: .curveEaseIn, x: 0, bool: true)
            return true
        }
}



