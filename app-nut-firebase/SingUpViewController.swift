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

class SingUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var referense: DatabaseReference?
    var handle: DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func addDatabaseReference() {
        referense = Database.database().reference()
        referense?.child("users").child("name").childByAutoId().setValue(nameTextField.text)
        referense?.child("users").child("lastname").childByAutoId().setValue(lastnameTextField.text)
        referense?.child("users").child("gender").childByAutoId().setValue(genderTextField.text)
        referense?.child("users").child("email").childByAutoId().setValue(emailTextField.text)
        referense?.child("users").child("password").childByAutoId().setValue(passwordTextField.text)
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
