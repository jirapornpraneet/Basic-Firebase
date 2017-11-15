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

    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileImageView()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Account"
    }

}
