//
//  FeedViewController.swift
//  app-nut-firebase
//
//  Created by Jiraporn Praneet on 14/11/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import SDWebImage
import OCThumbor

class FeedTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var universityNameLabel: UILabel!
    @IBOutlet weak var collegeNameLabel: UILabel!
    @IBOutlet weak var workNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUserResourceProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = R.string.localizable.feed()
    }

    func fetchUserResourceProfile() {
        let parameters = ["fields": "first_name, last_name, picture.type(large), cover,  work, education"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (_, result, _) in
            let resultDictionary = result as? NSDictionary
            let jsonString = resultDictionary?.toJsonString()
            let userResourceData: UserResourceData?
            userResourceData = UserResourceData(json: jsonString)

            let userResourceDataName = (userResourceData?.first_name)! + " " + (userResourceData?.last_name)!
            self.nameLabel.text = userResourceDataName

            let thumborProfileImageUrl = FunctionHelper().getThumborUrlFromImageUrl(imageUrlStr: (userResourceData?.picture?.data?.url)!, width: Int32(self.profileImageView.frame.size.width), height: Int32(self.profileImageView.frame.size.height))
            self.profileImageView.sd_setImage(with: thumborProfileImageUrl, completed: nil)
            self.profileImageView.contentMode = UIViewContentMode.scaleAspectFit

            self.coverImageView.sd_setImage(with: URL(string: (userResourceData?.cover?.source)!), completed: nil)
            self.workNameLabel.text = R.string.localizable.ที่((userResourceData?.work?[0].position?.name)!, (userResourceData?.work?[0].employer?.name)!)
            self.universityNameLabel.text = R.string.localizable.เคยศึกษาที่((userResourceData?.education?[2].concentration?[0].name)!, (userResourceData?.education?[2].school?.name)!)
            self.collegeNameLabel.text = R.string.localizable.เคยศึกษาที่("", (userResourceData?.education?[0].school?.name)!)
        }
    }
}
