//
//  Chat+Plus+Button.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 09/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

extension ChatLogViewController {
    func createPLusActionSheet(){
        let Alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

   
        
        
        let cameraAction = UIAlertAction(title: "  Camera", style: .default) { (UIAlertAction) in
            print("camera tapped")
        }
        cameraAction.setValue(#imageLiteral(resourceName: "camera-small"), forKey: "image")
        cameraAction.setAttributes
        Alert.addAction(cameraAction)
        
        
        
        
        let photoAction = UIAlertAction(title: "  Photo & Video Library", style: .default) { (UIAlertAction) in
                   print("Photo tapped")
            self.sendPhoto()
 
               }
               photoAction.setValue(#imageLiteral(resourceName: "photo"), forKey: "image")
               photoAction.setAttributes
               Alert.addAction(photoAction)
        
        
        
        let docAction = UIAlertAction(title: "  Document", style: .default) { (UIAlertAction) in
            print("Photo tapped")
        }
        docAction.setValue(#imageLiteral(resourceName: "document"), forKey: "image")
        docAction.setAttributes
        Alert.addAction(docAction)
        
        
        
        
        let locationAction = UIAlertAction(title: "  Location", style: .default) { (UIAlertAction) in
                  print("Location tapped")
              }
              locationAction.setValue(#imageLiteral(resourceName: "location"), forKey: "image")
              locationAction.setAttributes
              Alert.addAction(locationAction)
        
        
        
        let contactAction = UIAlertAction(title: "  Contact", style: .default) { (UIAlertAction) in
            print("Contact tapped")
        }
        contactAction.setValue(#imageLiteral(resourceName: "contact"), forKey: "image")
        contactAction.setAttributes
        Alert.addAction(contactAction)
        
        


        
             let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         Alert.addAction(cancelActionButton)
        self.present(Alert, animated: true, completion: nil)
        
    }
    
    
    func sendPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           var selectedImageFromPicker : UIImage?
            
            if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
                selectedImageFromPicker = editedImage
            }
             else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                   selectedImageFromPicker = originalImage
             }
            
            if let selectedImage = selectedImageFromPicker {
               uploadToFirebaseStorageUsingImage(selectedImage)
            }

               self.dismiss(animated: true, completion: nil )
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
   private func uploadToFirebaseStorageUsingImage(_ image: UIImage){
    
    let imageName = NSUUID().uuidString
    let ref = Storage.storage().reference().child("messages_images").child(imageName)
    
    
    if let uploadData = image.jpegData(compressionQuality: 0.5) {
        ref.putData(uploadData, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error sending photo")
            }else {
                ref.downloadURL { (url, error) in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                    }
                    else {
                        self.sendMessageWithImageUrl(imageUrl: url!.absoluteString)
                    }
                }
            }
        }
        
    }
    }
    
    private func sendMessageWithImageUrl(imageUrl : String){
        
        let ref = Database.database().reference().child("messages")
               
        let childRef = ref.childByAutoId()
               
        let toId = user!.id!
        
        let fromId = Auth.auth().currentUser!.uid
        
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        
        let values = ["imageUrl":imageUrl, "toId":toId, "fromId":fromId,"timestamp":timeStamp] as [String : Any]
               
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
    
}

