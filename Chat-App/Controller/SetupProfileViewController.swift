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

class SetupProfileViewController: UIViewController {
    
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var email = String()

    override func viewDidLoad() {
        print(email)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextButton(_ sender: Any) {
        createProfile()
    }
    
    func createProfile(){
        
        let name = nameTextField.cleanText
        let ref = Database.database().reference(fromURL: "https://chat-app-ae81b.firebaseio.com/")
          
        guard let uid = Auth.auth().currentUser?.uid else { return }
          
        let usersReference = ref.child("users").child(uid)
        let values = ["name": name, "email":email]
          
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
