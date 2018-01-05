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
import SDWebImage

class AccountViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        setShowData()
    }

    func setShowData() {
        //show date login with facebook
        let user = Auth.auth().currentUser
        if let user = user {
            firstnameLabel.text = user.displayName
            lastnameLabel.text = user.displayName
            genderLabel.text = ""
            emailLabel.text = user.email
            profileImageView.sd_setImage(with: user.photoURL, completed: nil)
        }
        //show data login with email & password
        let databaseReference = Database.database().reference()
        if  let uid = user?.uid {
            databaseReference.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    let profileImageURL = dict["pic"] as? String
                    let urlString = URL(string: profileImageURL!)
                    self.profileImageView.sd_setImage(with: urlString, completed: nil)
                    self.firstnameLabel.text = dict["firstname"] as? String
                    self.lastnameLabel.text = dict["lastname"] as? String
                    self.genderLabel.text = dict["gender"] as? String
                    self.emailLabel.text = dict["email"] as? String
                }
            }, withCancel: { (error) in
                print("Error", error)
            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = R.string.localizable.account()
    }

}
