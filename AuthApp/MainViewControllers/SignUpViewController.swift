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
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var togglePasswordButton: UIButton!
    @IBOutlet weak var toggleConfirmPasswordButton: UIButton!
    var isPasswordVisible = false
    var isConfirmPasswordVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func toggleConfirmPasswordVisibility(_ sender: Any) {
        isConfirmPasswordVisible.toggle()
        confirmPasswordTextField.isSecureTextEntry = !isConfirmPasswordVisible
                
        if let existingText = confirmPasswordTextField.text, isConfirmPasswordVisible {
            confirmPasswordTextField.text = ""
            confirmPasswordTextField.text = existingText
        }
        let imageName = isConfirmPasswordVisible ? "eye" : "eye.slash"
        toggleConfirmPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @IBAction func togglePasswordVisibility(_ sender: Any) {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
                
        if let existingText = passwordTextField.text, isPasswordVisible {
            passwordTextField.text = ""
            passwordTextField.text = existingText
        }
        let imageName = isPasswordVisible ? "eye" : "eye.slash"
        togglePasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showErrorAlert(message: "Please enter email, password, and confirm your password.")
            return
        }

        guard isValidEmail(email) else {
            showErrorAlert(message: "Please enter a valid email address (e.g. user@domain.com).")
            return
        }

        guard password == confirmPassword else {
            showErrorAlert(message: "Passwords do not match. Please try again.")
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
                self.showSuccessAlert(message: "Sign up successful! now you can Login", onOK: {
                    self.dismiss(animated: true)
                })
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
