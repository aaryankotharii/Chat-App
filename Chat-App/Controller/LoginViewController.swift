//
//  LoginViewController.swift
//  Chat-App
//
//  Created by Aaryan Kothari on 04/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var SignUpButton: UIButton!
    

    
    let passwordConstraints : String =  "Password should be minimum 8 characters, should contain atleast one uppercase letter, one lowercase letter, atleast one number digit and at least one special character"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            nameTextField.isHidden = true
            SignUpButton.titleLabel?.text = "Login"
        case 1:
            nameTextField.isHidden = false
            SignUpButton.titleLabel?.text = "Sign Up"

        default:
            nameTextField.isHidden = true
            SignUpButton.titleLabel?.text = "Login"
        }
    }
    
    
    
    
    //MARK: - Check empty fields
    func fieldCheck() -> String? {
        if nameTextField.cleanText == "" ||  emailTextField.cleanText == "" || passwordTextField.cleanText == ""
        { return "Please Fill in all the fields" }
        return nil
        }
    
    
    //MARK: - Validate Email
    func emailIsValid(_ email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
        }
    
    func validateEmail() -> String?{
        let cleanedEmail = emailTextField.cleanText
        if emailIsValid(cleanedEmail) == false { return "Please Enter a Valid email ID" }
        return nil
        }
    
    
    
    //MARK: - Validate Password
    func passwordIsValid(_ password : String) -> Bool? {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-za-z\\d$@$#!%*?&]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
        }
    
    func validatePassword() -> String? {
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if passwordIsValid(cleanedPassword) == false  {
            return passwordConstraints
            }
            return nil
            }
    
    
    //MARK: - All error check!
    func errorCheck() -> String?{
        if fieldCheck() != nil { return fieldCheck() }
        
        else if validateEmail() != nil { return validateEmail() }
        
        else if validatePassword() != nil { return validatePassword() }
        
        return nil
        }
    
    @IBAction func SignUpclicked(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            login()
        case 1:
            SignUp()
        default:
            login()
        }
    }
    
    
    
    func SignUp(){
        let name = nameTextField.cleanText
        let email = emailTextField.cleanText
        let password = passwordTextField.cleanText
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Erro creating user")
                return
            }
            else {
                let ref = Database.database().reference(fromURL: "https://chat-app-ae81b.firebaseio.com/")
                
                guard let uid = result?.user.uid else { return }
                
                let usersReference = ref.child("users").child(uid)
                let values = ["name": name, "email":email]
                
                usersReference.updateChildValues(values) { (error, ref) in
                    if error != nil {
                        print(error?.localizedDescription ?? "error saving data")
                        return
                    }
                    else{
                        print("Saved data")
                    }
                }
                print("SignUp success")
                self.goToViewController()
            }
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: emailTextField.cleanText, password: passwordTextField.cleanText) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error logging in")
            } else {
                print("login success")
                self.goToViewController()
        }
    }
    }
    
    func goToViewController(){
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "tovc") as? ChatsViewController
            self.present(controller!, animated: true, completion: nil)
        }
}
