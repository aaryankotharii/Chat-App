//
//  ImagePicker.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 05/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import UIKit

extension SetupProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func handSelectProfileImageView(){
        
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete Photo", style: .destructive) { (UIAlertAction) in
            self.deletePhoto()
        }

              let photoLibraryAction = UIAlertAction.init(title: "Choose Photo", style: .default) { (UIAlertAction) in
                 //photo Library
                 self.importImage()
              }
              let cameraAction = UIAlertAction.init(title: "Take photo", style: .default) { (UIAlertAction) in
                 
                 //acess camera
                 self.cameraTapped()
              }
              let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (UIAlertAction) in
                  //Cancel
                self.dismiss(animated: true, completion: nil)
              }
    
              alertController.addAction(deleteAction)
              alertController.addAction(photoLibraryAction)
              alertController.addAction(cameraAction)
              alertController.addAction(cancelAction)

              self.present(alertController, animated: true) {
                  print("presented camera action sheet")
              }
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
            profileImageView.image = selectedImage
        }

           self.dismiss(animated: true, completion: nil )
       }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled Image picker")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func importImage(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
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
    
    func deletePhoto(){
        //MARK:- LEFT
        print("delete")
    }
}
