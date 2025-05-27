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

        // Do any additional setup after loading the view.
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                print("Full error:", error)
                print("Code:", error.code)
                print("Description:", error.localizedDescription)
            } else {
                print("Signup successful")
            }
        }

    }

    @IBAction func returnToLoginButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

