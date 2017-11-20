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
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileImageView()
        setShowData()
    }

    func setProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        let databaseReference = Database.database().reference()
        if  let uid = Auth.auth().currentUser?.uid {
            databaseReference
                .child("users")
                .child(uid)
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

    func setShowData() {
        let databaseReference = Database.database().reference()
        if  let uid = Auth.auth().currentUser?.uid {
            databaseReference
                .child("users")
                .child(uid)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String: AnyObject] {
                        let firstnameString = dict["firstname"] as? String
                        let lastnameString = dict["lastname"] as? String
                        let genderString = dict["gender"] as? String
                        let emailString = dict["email"] as? String
                        self.firstnameLabel.text = firstnameString
                        self.lastnameLabel.text = lastnameString
                        self.genderLabel.text = genderString
                        self.emailLabel.text = emailString
                        
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
