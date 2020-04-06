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

class ChatLogViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var plusButton: NSLayoutConstraint!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user : User? {
        didSet{
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    var messages = [Message]()
    
   func observeMessages(){
    guard let uid = Auth.auth().currentUser?.uid else {return}
    
    let userMessagesref = Database.database().reference().child("user-messages").child(uid)
    
    userMessagesref.observe(.childAdded, with: { (snapshot) in
        let messageId = snapshot.key
        
        let messagesRef = Database.database().reference().child("messages").child(messageId)
        messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            guard let dictionary = snapshot.value as?[String:AnyObject] else { return }
            
            let message = Message()
            
            message.fromId = dictionary["fromId"] as! String
            message.text = dictionary["text"] as! String
            message.toId = dictionary["toId"] as! String
            message.timestamp = dictionary["timestamp"] as! Int
            
            
            if message.chatPatnerId() == self.user?.id {
            self.messages.append(message)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
            
            
        }, withCancel: nil)
    }, withCancel: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        chatTextField.delegate = self
        
         self.sendButton.isHidden = true
        addIndent(chatTextField)
        chatTextField.layer.borderColor = UIColor(named: "border")?.cgColor
        chatTextField.layer.borderWidth = 0.5
        
        chatTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        // Do any additional setup after loading the view.
    }
    
    func curveAnimation(button: UIButton, animationOptions: UIView.AnimationOptions, isReset: Bool) {
      let defaultXMovement: CGFloat = 240
      UIView.animate(withDuration: 1, delay: 0, options: animationOptions, animations: {
        button.transform = isReset ? .identity : CGAffineTransform.identity.translatedBy(x: defaultXMovement, y: 0)
      }, completion: nil)
    }
    
    
  @objc func textFieldDidChange(_ textField: UITextField) {
    if sendButton.isHidden {
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
        }, completion: { _ in
            self.sendButton.isHidden = false
            
            self.curveAnimation(button: self.cameraButton, animationOptions: .curveEaseOut, isReset: false)
        })
    }
    if chatTextField.text == ""{
        sendButton.isHidden = true
    }
    }
    
    

    @IBAction func plusClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func cameraClicked(_ sender: Any) {
    }
    
    
    @IBAction func micClicked(_ sender: Any) {
    }
    
    
    @IBAction func sendClicked(_ sender: Any) {
       sendData()
    }
    
    func sendData(){
        let ref = Database.database().reference().child("messages")
               
            let childRef = ref.childByAutoId()
               
        let toId = user!.id!
        
        let fromId = Auth.auth().currentUser!.uid
        
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        
        let values = ["text":chatTextField.text!, "toId":toId, "fromId":fromId,"timestamp":timeStamp] as [String : Any]
               
              // childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "couldnt send message")
            }else {
                print("usermessa ref")
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
                
                let messageId = childRef.key!
                
                userMessagesRef.updateChildValues([messageId:"a"])
                
                let recipientUserMessagesReference = Database.database().reference().child("user-messages").child(toId)
                
                recipientUserMessagesReference.updateChildValues([messageId:"a"])
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendData()
        return true
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? chatLogCollectionViewCell
                
        let message = messages[indexPath.item]
        cell!.messageTextView.text = message.text
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: view.frame.width, height: 80)
    }
}
