//
//  ViewController.swift
//  AuthApp
//
//  Created by esterelzek on 27/05/2025.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import FacebookCore
import GoogleSignIn
import Firebase

// MARK: - Login ViewController
class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var togglePasswordButton: UIButton!
    
    var isPasswordVisible = false

    // MARK: - Password Visibility
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
    
    // MARK: - Sign In Button
    @IBAction func SignInButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showErrorAlert(message: "Please enter both email and password.")
            return
        }

        guard isValidEmail(email) else {
            showErrorAlert(message: "Please enter a valid email address (e.g. user@domain.com).")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
                self.showErrorAlert(message: "This User Not Exist , Try to Sign Up")
                return
            }

            print("Login successful")
            self.showSuccessAlert(message: "Login successful!", onOK: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let gitHubVC = storyboard.instantiateViewController(withIdentifier: "GitHubRepositoriesViewController") as? GitHubRepositoriesViewController {
                        self.present(gitHubVC, animated: true)
                    }
            })
        }
    }

    // MARK: - SignUp Button
    @IBAction func navigatToSignUpScreenTapped(_ sender: Any) {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        present(signUpVC, animated: true)
    }
    
    // MARK: - facebook Button
    @IBAction func facebookButtonTapped(_ sender: Any) {
        if let accessToken = AccessToken.current {
            print("Using existing Facebook session")
            firebaseFacebookLogin(with: accessToken.tokenString)
        } else {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["email"], from: self) { result, error in
                if let error = error {
                    print("Facebook login failed: \(error.localizedDescription)")
                    return
                }
                guard let tokenString = AccessToken.current?.tokenString else {
                    print("No Facebook access token")
                    return
                }
                self.firebaseFacebookLogin(with: tokenString)
            }
        }
    }

    // MARK: - google Button
    @IBAction func googleButtonTapped(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                print("Google sign in failed: \(error.localizedDescription)")
                return
            }

            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Missing Google ID token")
                return
            }

            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken
            )

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase login with Google failed: \(error.localizedDescription)")
                    return
                }
        
                print("✅ Google sign-in success")
                self.showSuccessAlert(message: "Logged in with Google successful!", onOK: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let gitHubVC = storyboard.instantiateViewController(withIdentifier: "GitHubRepositoriesViewController") as? GitHubRepositoriesViewController {
                            self.present(gitHubVC, animated: true)
                    }
                })
               
            }
        }
    }
    
    // MARK: - firebase Facebook Login handeling
    func firebaseFacebookLogin(with token: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("Firebase login with Facebook failed: \(error.localizedDescription)")
                return
            }

            print("✅ Logged in with Facebook")
            self.showSuccessAlert(message: "Logged in with Facebook successful!", onOK: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let gitHubVC = storyboard.instantiateViewController(withIdentifier: "GitHubRepositoriesViewController") as? GitHubRepositoriesViewController {
                    self.present(gitHubVC, animated: true)
                }
            })
        }
    }

    // MARK: - clear Login Fields
    func clearLoginFields() {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
}
