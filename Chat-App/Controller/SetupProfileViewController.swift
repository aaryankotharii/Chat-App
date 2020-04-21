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
    
    //MARK:- Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet var countLabel: UILabel!
    
    var phone : String?
    var defaultImage = #imageLiteral(resourceName: "Default")

    
    //Initial Setup
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.hideKeyboardWhenTappedAround()
        setUpBorders()
        super.viewDidLoad()
        profileImageView.image = defaultImage
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handSelectProfileImageView)))
    }
    
    
    //MARK:- TextField Setup
    func setUpBorders(){
        let width = nameTextField.frame.width
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: 0, width: width,height: 0.5)
        bottomBorder.backgroundColor=UIColor.init(r: 193, g: 193, b: 193).cgColor
        nameTextField.layer.addSublayer(bottomBorder)
        let topBorder = CALayer()
        topBorder.backgroundColor=UIColor.init(r: 193, g: 193, b: 193).cgColor
        topBorder.frame = CGRect(x: 0, y: 36, width: width, height: 0.5)
        nameTextField.layer.addSublayer(topBorder)
    }
    
    @IBAction func editButton(_ sender: Any) {
        self.handSelectProfileImageView()
    }
    
    @IBAction func doneClicked(_ sender: UIButton) {
        createProfile()
    }
    
    
    
    //MARK:- Keep character count
    @IBAction func addingName(_ sender: UITextField) {
        if let text = sender.text {
        let count = text.count
        countLabel.text = "\(25 - count)"
        if text.count > 24{
            sender.text = String(sender.text?.prefix(24) ?? "")
        }
    }
    }
    
    
    //MARK:- *** Create New Profile ***
    func createProfile(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let name = nameTextField.cleanText

        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        if let profileImage = self.profileImageView.image,
            
            let uploadData = profileImage.jpegData(compressionQuality: 0.2){
                    
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }else{
                            let values = ["name": name, "phone": self.phone, "profileImageUrl": url?.absoluteString ?? ""]
                            self.registerUserIntoDataBasewithUID(uid: uid, values: values as [String : Any])
                        }
                    }
                }
            }
        }
    }
    
    
    private func registerUserIntoDataBasewithUID(uid : String, values : [String:Any]){
        
        let ref = Database.database().reference()
                    
        let usersReference = ref.child("users").child(uid)
        
          usersReference.updateChildValues(values) { (error, ref) in
              if let error = error {
                  print(error.localizedDescription)
              }
              else{
                print("User saved into database YAYAYAYAYY")
                self.goToViewController()
              }
        }
    }
    
    //GOTO TabbarVC
     func goToViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "tabbar")
        self.present(controller, animated: true, completion: nil)
        }
}


