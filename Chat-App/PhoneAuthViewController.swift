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

    
    //MARK:- Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var countryCodeLabel: UILabel!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var bgview: UIView!
    
    //MARK:- Variables
    var countryName : String = "India"
    var countryCode : String = "91"
    var phoneNumber : String?
    
    override func viewDidLoad() {
        

        initialUISetup()
        phoneTextField.becomeFirstResponder()
        super.viewDidLoad()
 


        // Do any additional setup after loading the view.
    }
    
    func initialUISetup(){
        //Large Title Setup
        self.title = "Edit Profile"
        
        //Background setup
        bgview.layer.borderColor = UIColor.init(r: 193, g: 193, b: 193).cgColor
        bgview.layer.borderWidth = 0.5
        
        //PhoneTextField UI Setup
        addIndent(phoneTextField)
        let border = CALayer()
        border.frame = CGRect(x: 0, y: 0, width: 0.5,height: 42)
        border.backgroundColor=UIColor.init(r: 193, g: 193, b: 193).cgColor
        phoneTextField.layer.addSublayer(border)
        //Done Button
        doneButton.isEnabled = false
    }
    
    
    @IBAction func addingPhoneNumber(_ sender: UITextField) {
        //MARK:- Adding space after 5 digits ( visual purposes only )
        if let text = sender.text{
            if text.count > 0 && text.count % 6 == 0 && text.last! != " " {
                    sender.text!.insert(" ", at:text.index(text.startIndex, offsetBy: text.count-1) )
                 }
                self.title = "+" + self.countryCode + " " + self.phoneTextField.text!
                 
                 if text.count == 11{
                     doneButton.isEnabled = true
                     phoneNumber = self.title?.replacingOccurrences(of: " ", with: "")
                 }else{
                     doneButton.isEnabled = false
                 }
            }
        }
    
    
    @IBAction func doneClicked(_ sender: Any) {
        //Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        if let number = self.phoneNumber {
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (id, error) in
                   if error != nil{
                    print(error?.localizedDescription ?? "error verifying number")
                   }
                   else{
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "OTPViewController") as OTPViewController
                    vc.id = id
                    vc.phone = number
                    self.navigationController?.pushViewController(vc, animated: true)
                   }
               }
        }
    }
}


///TODO:- Replace TableView by a single button

//MARK:- PhoneAuthVC TableView Delegate methods
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
