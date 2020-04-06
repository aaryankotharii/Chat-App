//
//  SetupProfileViewController.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 05/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class SetupProfileViewController: UIViewController {
    
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
        
    var email = String()

    override func viewDidLoad() {
        print(email)
        super.viewDidLoad()

        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handSelectProfileImageView)))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButton(_ sender: Any) {
        createProfile()
    }
    
    func createProfile(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let name = nameTextField.cleanText

        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        
        if let profileImage = self.profileImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.2){
        
        //if let uploadData = self.profileImageView.image!.pngData(){
            
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "error uploadign image")
                    return
                }
                else{
                    storageRef.downloadURL { (url, error) in
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                        }else{
                            let values = ["name": name, "email": self.email, "profileImageUrl": url?.absoluteString ?? ""]
                            
                            self.registerUserIntoDataBasewithUID(uid: uid, values: values)
                        }
                    }
                }
            }
        }
}
    
    
    private func registerUserIntoDataBasewithUID(uid : String, values : [String:Any]){
        //let ref = Database.database().reference(fromURL: "https://chat-app-ae81b.firebaseio.com/")
        
        let ref = Database.database().reference()
                    
        let usersReference = ref.child("users").child(uid)
        
          usersReference.updateChildValues(values) { (error, ref) in
              if error != nil {
                  print(error?.localizedDescription ?? "error saving data")
                  return
              }
              else{
                  print("Saved data")
                self.goToViewController()
              }
    }
    }
    
    func goToViewController(){
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ChatsViewController")
        self.present(controller, animated: true, completion: nil)
        }
    
}
