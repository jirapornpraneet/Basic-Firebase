//
//  SearchViewController.swift
//  app-nut-firebase
//
//  Created by Jiraporn Praneet on 13/11/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var incomeTextField: UITextField!
    @IBOutlet weak var expensesTextField: UITextField!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!

    var referense: DatabaseReference?
    var listsBalance: [String] = []
    var handle: DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        referense = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
        handle = referense?
            .child("users")
            .child(uid)
            .child("account")
            .child("balance")
            .observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? String {
                self.listsBalance.append(item)
                self.tableview.reloadData()
            }
        })
        }
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        if incomeTextField.text != "" && expensesTextField.text != "" {
            let income = Int(incomeTextField.text!)
            let expenses = Int(expensesTextField.text!)
            let balance = Int(income! - expenses!)
            let balanceString = String(balance)
            referense = Database.database().reference()
            if  let uid = Auth.auth().currentUser?.uid {
                referense?
                    .child("users")
                    .child(uid)
                    .child("account")
                    .child("balance")
                    .childByAutoId()
                    .setValue(balanceString)
            balanceLabel.text = balanceString
            }
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
        return listsBalance.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = listsBalance[indexPath.row]
        return cell
    }
}
