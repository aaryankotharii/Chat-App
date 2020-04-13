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

class ChatLogViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var textfieldRightConstraint: NSLayoutConstraint!
    
    @IBOutlet var keyboardBottomAnchot: NSLayoutConstraint!
    
    @IBOutlet var keyBoardView: UIView!
    
    
    
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
                guard let dictionary = snapshot.value as?[String:AnyObject] else { return }
                
                let message = Message()
                if let text = dictionary["text"]{
                      message.text = text as? String
                    if text as? String == "delete all messages"{
                        Database.database().reference().child("messages").removeValue()
                        Database.database().reference().child("user-messages").removeValue()
                        self.messages.removeAll()
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
                message.fromId = dictionary["fromId"] as! String
                message.toId = dictionary["toId"] as! String
                message.timestamp = dictionary["timestamp"] as! Int
                
                if let imageUrl = dictionary["imageUrl"] {
                    message.imageUrl = imageUrl as! String
                }
                
                
                if message.chatPatnerId() == self.user?.id {
                self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        
                        //scrollToLAst index
                        let indexPath = IndexPath(item: self.messages.count-1, section: 0)
                        
                        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
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
            
            collectionView.alwaysBounceVertical=true
            collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 7, right: 0)
            // Do any additional setup after loading the view.
        }
        
        func curveAnimation(button: UIButton, animationOptions: UIView.AnimationOptions, x: CGFloat, bool : Bool) {
            UIView.animate(withDuration: 0.01, delay: 0, options: animationOptions, animations: {
                self.sendButton.alpha = bool ? 0 : 1
                self.textfieldRightConstraint.isActive = !bool
                self.sendButton.isHidden = bool
                button.alpha = CGFloat(bool ? 1: 0)
            button.transform = CGAffineTransform.identity.translatedBy(x: x, y: 0)
            }, completion: nil)
        }
        
        
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
        

        @IBAction func plusClicked(_ sender: Any) {
            self.createPLusActionSheet()
        }
        
        
        @IBAction func cameraClicked(_ sender: Any) {
        }
        
        
        @IBAction func micClicked(_ sender: Any) {
        }
        
        
        @IBAction func sendClicked(_ sender: Any) {
           sendData()
            self.curveAnimation(button: self.cameraButton, animationOptions: .curveEaseIn, x: 0, bool: true)
            self.curveAnimation(button: self.micButton, animationOptions: .curveEaseIn, x: 0, bool: true)
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
                    
                    self.chatTextField.text = nil
                    self.sendButton.isHidden = true
                    
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
        
        
        
        
        
    
        //MARK:- CollectiomView Delegate Methods
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return messages.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            var cellToBeReturned = UICollectionViewCell()
            
            let message = messages[indexPath.item]
            
            if message.imageUrl != nil {
                //cell.bubbleWidthAnchor.constant = 327
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath) as! ChatLogImageCollectionViewCell
                
                setupImageCell(cell: cell, message: message)
                cellToBeReturned = cell
            }
            else {
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! chatLogCollectionViewCell
                    
                cell.messageTextView.text = message.text
                
                setupMessageCell(cell: cell, message: message)
                cell.bubbleWidthAnchor.constant = extimateFrameForText(text: message.text!).width + 32
                cellToBeReturned = cell
            }
            return cellToBeReturned
        }
    
    @objc func handleImageTap(tapGesture: UITapGestureRecognizer){
        if let imageView = tapGesture.view as? UIImageView{
            self.performZoom(startingImageView: imageView)
        }
    }
    
    var startingImageFrame : CGRect?
    var backgroundView : UIView?
    var startingImageView : UIImageView?
    
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
                zoomOutImageView.removeFromSuperview()
                self.backgroundView?.removeFromSuperview()
                self.startingImageView?.isHidden = false
            }
        }
        
    }
    
    private func setupImageCell(cell : ChatLogImageCollectionViewCell, message : Message){
        if let imageUrl = message.imageUrl{
           cell.imageView.loadImageUsingCacheWithUrlString(urlString: imageUrl)
            cell.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
        }
        if message.fromId == Auth.auth().currentUser?.uid {
                   //green Cell
            cell.chatBubble.backgroundColor = UIColor(named: "tochatcolor")
            cell.bubbleLeftAnchor.isActive = false
            cell.bubbleRightAnchor.isActive = true
               }else {
                   //white cell
            cell.chatBubble.backgroundColor = UIColor(named: "fromchatcolor")
            cell.bubbleRightAnchor.isActive = false
            cell.bubbleLeftAnchor.isActive = true
               }
    }
    
        
        private func setupMessageCell(cell : chatLogCollectionViewCell, message : Message){
            
            if message.fromId == Auth.auth().currentUser?.uid {
                       //Blue Cell
                cell.chatBubble.backgroundColor = UIColor(named: "tochatcolor")
                cell.bubbleLeftAnchor.isActive = false
                cell.bubbleRightAnchor.isActive = true
                   }else {
                       //grey message
                cell.chatBubble.backgroundColor = UIColor(named: "fromchatcolor")
                cell.bubbleRightAnchor.isActive = false
                cell.bubbleLeftAnchor.isActive = true
                   }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            var height : CGFloat = 327
            if let text = messages[indexPath.item].text{
                height = extimateFrameForText(text: text).height + 20
            }
            print("height is",height,messages[indexPath.item].text)
            return CGSize(width: view.frame.width, height: height)
        }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
        
        
        //MARK:- Height constraints for chat bubble
        private func extimateFrameForText(text: String) -> CGRect {
            let size = CGSize(width: 327, height: 1000)
            
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
           }
    }


