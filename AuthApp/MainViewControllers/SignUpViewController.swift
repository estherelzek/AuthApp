//
//  SignUpViewController.swift
//  AuthApp
//
//  Created by esterelzek on 27/05/2025.
//

import UIKit
import Firebase
import FirebaseAuth


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showErrorAlert(message: "Please enter both email and password.")
            return
        }
        
        guard isValidEmail(email) else {
            showErrorAlert(message: "Please enter a valid email address (e.g. user@domain.com).")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                print("Full error:", error)
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                if let loginVC = self.presentingViewController as? ViewController {
                    loginVC.clearLoginFields()
                }
                    self.dismiss(animated: true)
                }
                
            }
        }
    
    @IBAction func returnToLoginButtonTapped(_ sender: Any) {
        if let loginVC = self.presentingViewController as? ViewController {
            loginVC.clearLoginFields()
        }
            self.dismiss(animated: true)
    }
}
