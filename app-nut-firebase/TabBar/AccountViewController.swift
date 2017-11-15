//
//  AccountViewController.swift
//  app-nut-firebase
//
//  Created by Jiraporn Praneet on 14/11/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstnameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileImageView()
        setShowDataFirstName()
    }

    func setProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        let databaseReference = Database.database().reference()
        if  Auth.auth().currentUser != nil {
            databaseReference
                .child("users")
                .child("profileImage")
                .observeSingleEvent(of:
                    .value, with: { (snapshot) in
                        if let dict = snapshot.value as? [String: AnyObject] {
                            if let profileImageURL = dict["pic"] as? String {
                                let url = URL(string: profileImageURL)
                                URLSession.shared.dataTask(with: url!,
                                                           completionHandler: { (data, _, error) in
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

    func setShowDataFirstName() {
        let databaseReference = Database.database().reference()
        if  Auth.auth().currentUser != nil {
            databaseReference
                .child("users")
                .child("firstname").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String: AnyObject] {
                        let firstnameString = dict["firstname"] as? String
                        self.firstnameLabel.text = firstnameString
                    }
                }, withCancel: { (error) in
                    print("Error", error)
                })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Account"
    }

}
