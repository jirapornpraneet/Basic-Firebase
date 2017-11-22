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

class AccountTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var incomesLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var incomesTextField: UITextField!
    @IBOutlet weak var expensesTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!

    var referense: DatabaseReference?
    var listsBalance: [String] = []
    var listsDate: [String] = []
    var handle: DatabaseHandle?
    var dateString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd-MM-yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        dateString = date

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
            referense?
                .child("users")
                .child(uid)
                .child("account")
                .child("date")
                .observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? String {
                    print("Item", item)
                    self.listsDate.append(item)
                    self.tableview.reloadData()
                }
            })
        }
    }

    @IBAction func selectDatePicker(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd-MM-yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        dateString = date
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        if incomesTextField.text != "" && expensesTextField.text != "" {
            let income = Int(incomesTextField.text!)
            let expenses = Int(expensesTextField.text!)
            let balance = Int(income! - expenses!)
            let balanceString = String(balance)
            referense = Database.database().reference()
            if  let uid = Auth.auth().currentUser?.uid {
                referense?
                    .child("users")
                    .child(uid)
                    .child("account")
                    .child("date")
                    .childByAutoId()
                    .setValue(dateString)
                referense?
                    .child("users")
                    .child(uid)
                    .child("account")
                    .child("balance")
                    .childByAutoId()
                    .setValue(balanceString)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Search"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listsBalance.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AccountTableViewCell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        cell?.dateLabel.text = listsDate[indexPath.row]
        cell?.incomesLabel.text = "9999"
        cell?.expensesLabel.text = "8888"
        cell?.balanceLabel.text = listsBalance[indexPath.row]
        return cell!
    }
}
