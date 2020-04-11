//
//  OTPViewController.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 11/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FirebaseAuth

class OTPViewController: UIViewController {

    var id : String?
    var phone : String?
    
    @IBOutlet var otpTextField: UITextField!
    
    @IBOutlet var otpLabel: UILabel!
    
    
    override func viewDidLoad() {
        self.otpTextField.becomeFirstResponder()
        print(id)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func otp(_ sender: UITextField) {
        var last = ""
        if let text = sender.text {
            let count = text.count
                if count > 0{
                    let label : UILabel = self.view.viewWithTag(count) as! UILabel
                    last = String(text.suffix(1))
                    label.text = last
                    if count < 6 {
                    for i in count+1...6{
                        let label : UILabel = self.view.viewWithTag(i) as! UILabel
                        label.text = "﹣"
                    }
                    }
                }else{
                    let label : UILabel = self.view.viewWithTag(1) as! UILabel
                    label.text = "﹣"
            }
        }
        
        if sender.text?.count == 6{
            otpTextField.isEnabled = false
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: id!, verificationCode: otpTextField.text!)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    self.otpTextField.isEnabled = true
                    self.otpTextField.text = nil
                    self.resetLabels()
                    self.otpTextField.becomeFirstResponder()
                }
                else{
                    print("success")
                    self.goToViewController()
                }
            }
        }
    }
    func goToViewController(){
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ChatsViewController")
        self.present(controller, animated: true, completion: nil)
        }
    
    func resetLabels(){
        for i in 1...7{
            let label : UILabel = self.view.viewWithTag(i) as! UILabel
            label.text = "﹣"
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
