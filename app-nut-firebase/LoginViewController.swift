//
//  LoginViewController.swift
//  app-nut-firebase
//
//  Created by Jiraporn Praneet on 7/11/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self

        let tapGestureRecognizerKeyboard: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizerKeyboard)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginClicked(self)
        }
        return true
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func setLoginButtonIsEnabled() {
        let editTexts = [emailTextField, passwordTextField]
        let emptyCount = editTexts
            .filter { (textField) -> Bool in
            textField?.text == "" }
            .count
        loginButton.isEnabled = emptyCount == 0
    }
    
    @IBAction func emailEditingChanged(_ sender: Any) {
        setLoginButtonIsEnabled()
    }
    
    @IBAction func passwordEditingChanged(_ sender: Any) {
        setLoginButtonIsEnabled()
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!,
                           password: passwordTextField.text!) { (_, error) in
            if error == nil {
                let alertController = UIAlertController(title: "เข้าสู่ระบบ",
                                                        message: "เข้าสู่ระบบเรียบร้อย",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ตกลง",
                                                        style: UIAlertActionStyle.default,
                                                        handler: { (_) in
                                                            let vc = self.storyboard?
                                                                .instantiateViewController(withIdentifier: "Home")
                                                            self.show(vc!, sender: sender)
                }))
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "ข้อผิดพลาด",
                                                        message: error?.localizedDescription,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ตกลง",
                                                        style: .cancel,
                                                        handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
