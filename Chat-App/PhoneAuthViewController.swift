//
//  PhoneAuthViewController.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 10/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhoneAuthViewController: UIViewController {

    @IBOutlet var phoneTextField: UITextField!
    
    @IBOutlet var otpTextField: UITextField!
    
    var verificationId : String?
    override func viewDidLoad() {
        super.viewDidLoad()
 

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneTextField.text!, uiDelegate: nil) { (id, error) in
             if error != nil{
                 print(error)
             }
             else{
                self.verificationId = id
             }
         }
    }
    
    @IBAction func id(_ sender: Any) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId!, verificationCode: otpTextField.text!)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            else{
                print("success")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
