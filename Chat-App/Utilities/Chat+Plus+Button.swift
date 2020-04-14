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
import CoreServices

extension ChatLogViewController {
    func createPLusActionSheet(){
        let Alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

   
        
        
        let cameraAction = UIAlertAction(title: "  Camera", style: .default) { (UIAlertAction) in
            print("camera tapped")
            self.cameraTapped()
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
    
     func cameraTapped() {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            let alertController = UIAlertController.init(title: nil, message: "No camera.", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "<-- Return", style: .default, handler: {(alert: UIAlertAction!) in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

        }
        else{
               let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                present(imagePicker, animated: true)
        }
    }
    
    
    func sendPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
                uploadToFirebaseStorageUsingVideo(videoUrl)
        }else{
            handleImageselectedForInfo(info: info)
        }
        


               self.dismiss(animated: true, completion: nil )
    }
    
    private func uploadToFirebaseStorageUsingVideo(_ url : URL){
        let fileName = "movie.mov"
        let videoRef = Storage.storage().reference().child("messages_videos").child(fileName)
        
        let videoData: Data = try! Data(contentsOf: url)
                
        let uplaodTask = videoRef.putData(videoData,  metadata: nil) { (metadata, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Video not uploaded")
            }else{
                videoRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    }else{
                        if let videoUrl = url{
                            self.sendMessageWithVideoUrl(videourl: videoUrl.absoluteString)
                        }
                    }
                })
            }
        }
        
        uplaodTask.observe(.progress) { (snapshot) in
            if let progress = snapshot.progress{
            print(progress.completedUnitCount)
            }
        }
        
        uplaodTask.observe(.success) { (snapshot) in
            print("SUCCESS!")
        }
        
    }
    
    
    private func handleImageselectedForInfo(info: [UIImagePickerController.InfoKey:Any]){
        var selectedImageFromPicker : UIImage?
         
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage").rawValue)] as? UIImage{
             selectedImageFromPicker = editedImage
         }
        else if let originalImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
                selectedImageFromPicker = originalImage
          }
         
         if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(selectedImage)
         }
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
    
    private func sendMessageWithVideoUrl(videourl : String){
        
        let ref = Database.database().reference().child("messages")
               
        let childRef = ref.childByAutoId()
               
        let toId = user!.id!
        
        let fromId = Auth.auth().currentUser!.uid
        
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        
        let values = ["videoUrl":videourl, "toId":toId, "fromId":fromId,"timestamp":timeStamp] as [String : Any]
               
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

