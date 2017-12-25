//
//  ResetPasswordViewController.swift
//  app-nut-firebase
//
//  Created by Jiraporn Praneet on 7/11/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
    @IBAction func emailEditingChanged(_ sender: Any) {
        if emailTextField.text != "" {
            resetPasswordButton.isEnabled = true
        } else {
            resetPasswordButton.isEnabled = false
        }
    }

    @IBAction func resetPasswordCliked(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            var title = ""
            var message = ""
            if error != nil {
                title = "Error"
                message = (error?.localizedDescription)!
            } else {
                title = "Success"
                message = "Password reset email sent"
                self.emailTextField.text = ""
            }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
