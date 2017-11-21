//
//  SearchViewController.swift
//  app-nut-firebase
//
//  Created by Jiraporn Praneet on 13/11/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!

    var referense: DatabaseReference?
    var listsUserName: [String] = []
    var handle: DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        referense = Database.database().reference()
        handle = referense?.child("users").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? String {
                self.listsUserName.append(item)
                self.tableview.reloadData()
            }
        })
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        referense = Database.database().reference()
        if userNameTextField.text != "" {
            referense?.child("users").childByAutoId().setValue(userNameTextField.text)
            userNameTextField.text = ""
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Search"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listsUserName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = listsUserName[indexPath.row]
        return cell
    }
}
