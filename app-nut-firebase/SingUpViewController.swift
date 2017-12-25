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

class SingUpViewController: UIViewController, UITextFieldDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var singUpButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!

    var handle: DatabaseHandle?
    var genderList: [String] = ["Male", "Female"]
    var genderName: String = ""
    var databaseReference = Database.database().reference()
    var storageReference = Storage.storage().reference()

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
        databaseReference
            .child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .updateChildValues(["firstname": firstnameTextField.text!])
        databaseReference
            .child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .updateChildValues(["lastname": lastnameTextField.text!])
        databaseReference
            .child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .updateChildValues(["gender": genderName])
        databaseReference
            .child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .updateChildValues(["email": emailTextField.text!])
        databaseReference
            .child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .updateChildValues(["password": passwordTextField.text!])
        databaseReference
            .child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .updateChildValues(["confirmpassword": confirmPasswordTextField.text!])
    }

    func setProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        if let uid = Auth.auth().currentUser?.uid {
            databaseReference.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    if let profileImageURL = dict["pic"] as? String {
                        let url = URL(string: profileImageURL)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                        DispatchQueue.main.async {
                            self.profileImageView.image = UIImage(data: data!)
                            }
                        }).resume()
                    }
                }
            })
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        var selectedImageFromPicker: UIImage?

        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func uploadImageButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }

    func saveProfileImageView() {
        let imageName = NSUUID().uuidString
        let storedImage = storageReference.child("profileUserImages").child(imageName)

        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
            storedImage.putData(uploadData, metadata: nil, completion: { (_, error) in
                if error != nil {
                    print(error!)
                    return
                }

            storedImage.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!)
                    return
                }

                if let urlText = url?.absoluteString {
                    self.databaseReference
                        .child("users")
                        .child((Auth.auth().currentUser?.uid)!)
                        .updateChildValues(["pic": urlText], withCompletionBlock: { (error, _) in
                            if error != nil {
                                print(error!)
                                return
                            }
                        })
                }
            })
            })
        }
    }

    @IBAction func singUpClicked(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (_, error) in
            if error == nil {
                let alertController = UIAlertController(title: "Register", message: "Success",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK",
                                                        style: UIAlertActionStyle.default, handler: { (_) in
                                                            self.addDatabaseReference()
                                                            self.saveProfileImageView()
                                                            let vc = self.storyboard?
                                                                .instantiateViewController(withIdentifier: "Login")
                                                            self.show(vc!, sender: sender)
                }))
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Something wrong!",
                                                        message: error?.localizedDescription,
                                                        preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK",
                                                  style: .cancel,
                                                  handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
