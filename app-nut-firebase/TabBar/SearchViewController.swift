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
    @IBOutlet weak var incomesLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var incomesTextField: UITextField!
    @IBOutlet weak var expensesTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!

    var handle: DatabaseHandle?
    var databaseReference = Database.database().reference()
    var dateString: String?
    var balancesString: [String] = []
    var datesString: [String] = []
    var incomesString: [String] = []
    var expensesString: [String] = []
    var incomes: Int?
    var expenses: Int?
    var balances: Int?
    var balanceString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd-MM-yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        dateString = date

        getDataToStringArray()

        let tapGestureRecognizerKeyboard: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizerKeyboard)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func selectDatePicker(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd-MM-yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        dateString = date
        datePicker.minuteInterval = 60
        getDataToStringArray()
        tableview.reloadData()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == incomesTextField {
            expensesTextField.becomeFirstResponder()
        } else if textField == expensesTextField {
           saveButtonClicked(self)
        }
        return true
    }

    func getDataToStringArray() {
        if let uid = Auth.auth().currentUser?.uid {
            let childData = databaseReference
                .child("users")
                .child(uid)
                .child("accounts")
                .child("date")
                .child(dateString!)

            datesString.removeAll()
            childData.observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? String {
                    self.datesString.append(item)
                    self.tableview.reloadData()
                }
                self.tableview.reloadData()
            })

            incomesString.removeAll()
            handle = childData.child("incomes").observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? String {
                    self.incomesString.append(item)
                    self.tableview.reloadData()
                }
                self.tableview.reloadData()
            })

            expensesString.removeAll()
            childData.child("expenses").observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? String {
                    self.expensesString.append(item)
                    self.tableview.reloadData()
                }
                self.tableview.reloadData()
            })

            balancesString.removeAll()
            childData.child("balances").observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? String {
                    self.balancesString.append(item)
                    self.tableview.reloadData()
                }
                self.tableview.reloadData()
            })
        }
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        if incomesTextField.text == "" {
            incomes = 0
            expenses = Int(expensesTextField.text!)
            saveDataToFireBase()
        } else if expensesTextField.text == "" {
            incomes = Int(incomesTextField.text!)
            expenses = 0
            saveDataToFireBase()
        } else {
            incomes = Int(incomesTextField.text!)
            expenses = Int(expensesTextField.text!)
            saveDataToFireBase()
        }
    }

    func saveDataToFireBase() {
        balances = Int(incomes! - expenses!)
        balanceString = String(balances!)
        if  let uid = Auth.auth().currentUser?.uid {
            let childData = databaseReference
                .child("users")
                .child(uid)
                .child("accounts")
                .child("date")
                .child(dateString!)

            childData.observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? String {
                    self.datesString.append(item)
                }
            })

            childData.child("incomes")
                .childByAutoId()
                .setValue(String(incomes!))

            childData.child("expenses")
                .childByAutoId()
                .setValue(String(expenses!))

            childData.child("balances")
                .childByAutoId()
                .setValue(balanceString)
        }
        incomesTextField.text = ""
        expensesTextField.text = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Search"
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomesString.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AccountTableViewCell
            cell?.incomesLabel.text = incomesString[indexPath.row]
            cell?.expensesLabel.text = expensesString[indexPath.row]
            cell?.balanceLabel.text = balancesString[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateString
    }
}
