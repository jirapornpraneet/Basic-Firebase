//
//  ViewController.swift
//  app-nut-firebase
//
//  Created by Jiraporn Praneet on 7/11/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func logOutClicked(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let alertController = UIAlertController(title: "ออกสู่ระบบ",
                                                        message: "ออกสู่ระบบเรียบร้อย",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ตกลง",
                                                        style: UIAlertActionStyle.default,
                                                        handler: { (_) in
                                                            let vc = self.storyboard?
                                                                .instantiateViewController(withIdentifier: "Login")
                                                            self.show(vc!, sender: sender)
                }))
                self.present(alertController, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
