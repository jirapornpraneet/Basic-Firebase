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
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var showPasswordButton: UIButton!
    @IBOutlet var loginWithFacebookButton: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self

        let tapGestureRecognizerKeyboard: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizerKeyboard)

        self.loginWithFacebookButton.delegate = self
    }

    func alertControllerSuccess() {
        let alertController = UIAlertController(title: R.string.localizable.logIn(),
                                                message: R.string.localizable.success(),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: R.string.localizable.oK(),
                                                style: UIAlertActionStyle.default,
                                                handler: { (_) in
                                                    let vc = R.storyboard.main.tabBar()
                                                    self.show(vc!, sender: send)
        }))
        self.present(alertController, animated: true, completion: nil)
    }

    func alertControllerError(error: Error) {
        let alertController = UIAlertController(title: R.string.localizable.somethingWrong(),
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: R.string.localizable.oK(),
                                                style: .cancel,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func loginButton(_ loginButton: FBSDKLoginButton!,
                     didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (_, error) in
            if  error != nil {
                self.alertControllerError(error: error!)
            }
            self.alertControllerSuccess()
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("LogOut Success !!")
    }

    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
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

    @IBAction func showPasswordClicked(_ sender: Any) {
        let origImage = R.image.icon_eye_red()
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        showPasswordButton.setImage(tintedImage, for: .normal)

        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.tintColor = UIColor.red
        } else {
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.tintColor = UIColor.white
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    @IBAction func loginClicked(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (_, error) in
            if error != nil {
                self.alertControllerError(error: error!)
            }
            self.alertControllerSuccess()
        }
    }
}
