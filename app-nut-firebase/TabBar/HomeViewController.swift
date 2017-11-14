//
//  HomeViewController.swift
//  app-nut-firebase
//
//  Created by Jiraporn Praneet on 13/11/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 7)
        formatter.locale = Locale(identifier: "th")
        let result = formatter.string(from: date)
        dateLabel.text = result
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Home"
    }
}
