//
//  SingUpViewController.swift
//  app-nut-firebase
//
//  Created by Jiraporn Praneet on 7/11/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SingUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var singUpButton: UIButton!

    var referense: DatabaseReference?
    var handle: DatabaseHandle?
    var genderList: [String] = ["Male", "Female"]
    var genderName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self

        let tapGestureRecognizerKeyboard: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizerKeyboard)

        let genderSelect: String = genderList[genderSegmentedControl.selectedSegmentIndex]
        genderName = genderSelect
    }

    @IBAction func selectGenderSegmented(_ sender: Any) {
        switch genderSegmentedControl.selectedSegmentIndex {
        case 0:
            genderName = "Male"
        case 1:
            genderName = "Female"
        default:
            break
        }
        let genderSelect: String = genderList[genderSegmentedControl.selectedSegmentIndex]
        genderName = genderSelect
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstnameTextField {
            lastnameTextField.becomeFirstResponder()
        } else if textField == lastnameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField ==  confirmPasswordTextField {
            singUpClicked(self)
        }
        return true
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func setSingUpButtonIsEnabled() {
        let editTexts = [firstnameTextField,
                         lastnameTextField,
                         emailTextField,
                         passwordTextField,
                         confirmPasswordTextField]
        let emptyCount = editTexts
            .filter { (textField) -> Bool in
                textField?.text == "" }
            .count
        singUpButton.isEnabled = emptyCount == 0
    }

    @IBAction func firstnameEditingChanged(_ sender: Any) {
        setSingUpButtonIsEnabled()
    }

    @IBAction func lastnameEditingChanged(_ sender: Any) {
        setSingUpButtonIsEnabled()
    }

    @IBAction func emailEditingChanged(_ sender: Any) {
        setSingUpButtonIsEnabled()
    }

    @IBAction func passwordEditingChanged(_ sender: Any) {
        setSingUpButtonIsEnabled()
    }

    @IBAction func confirmPasswordEditingChanged(_ sender: Any) {
        setSingUpButtonIsEnabled()
    }

    func addDatabaseReference() {
        referense = Database.database().reference()
        referense?.child("users").child("firstname").childByAutoId().setValue(firstnameTextField.text)
        referense?.child("users").child("lastname").childByAutoId().setValue(lastnameTextField.text)
        referense?.child("users").child("gender").childByAutoId().setValue(genderName)
        referense?.child("users").child("email").childByAutoId().setValue(emailTextField.text)
        referense?.child("users").child("password").childByAutoId().setValue(passwordTextField.text)
        referense?.child("users").child("confirmPassword").childByAutoId().setValue(confirmPasswordTextField.text)
    }

    @IBAction func singUpClicked(_ sender: Any) {
        Auth.auth()
            .createUser(withEmail: emailTextField.text!,
                        password: passwordTextField.text!) { (_, error) in
            if error == nil {
                let alertController =
                    UIAlertController(title: "ลงทะเบียนผู้ใช้งาน",
                                      message: "ลงทะเบียนผู้ใช้งานเรียบร้อย",
                                      preferredStyle: .alert)
                alertController
                    .addAction(UIAlertAction(title: "ตกลง",
                                             style: UIAlertActionStyle.default,
                                             handler: { (_) in
                                                self.addDatabaseReference()
                                                let vc = self.storyboard?
                                                    .instantiateViewController(withIdentifier: "Login")
                                                self.show(vc!, sender: sender)
                    }))
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "ข้อผิดพลาด",
                                                        message: error?.localizedDescription,
                                                        preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "ตกลง",
                                                  style: .cancel,
                                                  handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                                }
        }
    }
}
