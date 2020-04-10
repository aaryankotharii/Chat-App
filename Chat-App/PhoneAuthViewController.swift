//
//  PhoneAuthViewController.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 10/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhoneAuthViewController: UIViewController{

    
    @IBOutlet var otpTextField: UITextField!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var countryCodeLabel: UILabel!
    
    @IBOutlet var phoneTextField: UITextField!
    
    var countryName : String = "India"{
        didSet{
            print("set")
        }
    }
    
    var countryCode : String = "+91"
    
    var verificationId : String?
    override func viewDidLoad() {
        
        let str = "8286040000"
        let final2 = str.inserting(separator: " ", every: 5)
        print(final2)      // "11:23:12:45:1\n"

        super.viewDidLoad()
 
        view.layer.borderColor = UIColor.init(r: 193, g: 193, b: 193).cgColor
        view.layer.borderWidth = 0.5
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addingPhoneNumber(_ sender: Any) {
        if phoneTextField.text != "" {
            if phoneTextField.text!.count == 5{
                phoneTextField.text = phoneTextField.text! + " "
        }
    }
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
    
}


extension PhoneAuthViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "countrycell")
            cell?.textLabel?.text = self.countryName
            return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "countries") as countriesViewController
        vc.mainViewController = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42.8
    }
}
