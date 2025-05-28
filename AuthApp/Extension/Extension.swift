//
//  Extension.swift
//  AuthApp
//
//  Created by esterelzek on 27/05/2025.
//

import Foundation
import UIKit

extension GitHubRepositoriesViewController {
   
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                self.viewModel.fetchRepositories(reset: false)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }

    func setupLoader() {
        loader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}
import UIKit

extension UIViewController {
    func showErrorAlert(message: String, title: String = "Error") {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
     func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    func showSuccessAlert(title: String = " ✅ Success", message: String, onOK: @escaping () -> Void) {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                onOK()
            }))
            self.present(alert, animated: true)
        }
}
