//
//  ViewController.swift
//  app-nut-firebase
//
//  Created by Jiraporn Praneet on 7/11/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AVFoundation
import AZTabBar

class TabBarViewController: UIViewController, AZTabBarDelegate {

    var tabController: AZTabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()
        var icons = [UIImage]()
        icons.append(#imageLiteral(resourceName: "ic_home_outline"))
        icons.append(#imageLiteral(resourceName: "ic_search_outline"))
        icons.append(#imageLiteral(resourceName: "ic_camera_outline"))
        icons.append(#imageLiteral(resourceName: "ic_heart_outline"))
        icons.append(#imageLiteral(resourceName: "ic_account_outline"))

        var sIcons = [UIImage]()
        sIcons.append(#imageLiteral(resourceName: "ic_home"))
        sIcons.append(#imageLiteral(resourceName: "ic_search"))
        sIcons.append(#imageLiteral(resourceName: "ic_camera"))
        sIcons.append(#imageLiteral(resourceName: "ic_heart"))
        sIcons.append(#imageLiteral(resourceName: "ic_account"))

        tabController = AZTabBarController.insert(into: self, withTabIcons: icons, andSelectedIcons: sIcons)
        tabController.delegate = self

        addActionsTabBarToViewController()
        customizationsTabBar()

    }

    func addActionsTabBarToViewController() {
        let myHomeViewController = R.storyboard.main.homeViewController()
        let mySearchViewController = R.storyboard.main.searchViewController()
        let myCameraViewController = R.storyboard.main.cameraViewController()
        let myFeedViewController = R.storyboard.main.feedViewController()
        let myAccountViewController = R.storyboard.main.accountViewController()

        tabController.setViewController(myHomeViewController!, atIndex: 0)
        tabController.setViewController(mySearchViewController!, atIndex: 1)
        tabController.setViewController(myCameraViewController!, atIndex: 2)
        tabController.setViewController(myFeedViewController!, atIndex: 3)
        tabController.setViewController(myAccountViewController!, atIndex: 4)

        tabController?.setAction(atIndex: 4) {
        }
        tabController?.setAction(atIndex: 3) {
        }
        tabController?.setAction(atIndex: 2) {
        }
        tabController?.setAction(atIndex: 1) {
        }
        tabController?.setAction(atIndex: 0) {
        }
    }

    func customizationsTabBar() {
        tabController.defaultColor = UIColor(red: 0.95, green: 0.58, blue: 0.58, alpha: 1.0)
        tabController.selectedColor = UIColor(red: 0.99, green: 0.33, blue: 0.44, alpha: 1.0)
        tabController.highlightColor = .white
        tabController.highlightedBackgroundColor = .green
        tabController.buttonsBackgroundColor = .white
        tabController.selectionIndicatorColor = .green
        tabController.selectionIndicatorHeight = 0
        tabController.separatorLineColor = .black
        tabController.separatorLineVisible = false
        tabController.animateTabChange = true

        tabController.setTitle(R.string.localizable.home(), atIndex: 0)
        tabController.setTitle(R.string.localizable.search(), atIndex: 1)
        tabController.setTitle(R.string.localizable.camera(), atIndex: 2)
        tabController.setTitle(R.string.localizable.feed(), atIndex: 3)
        tabController.setTitle(R.string.localizable.profile(), atIndex: 4)
        tabController.onlyShowTextForSelectedButtons = true
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return tabController
    }

    func tabBar(_ tabBar: AZTabBarController, statusBarStyleForIndex index: Int) -> UIStatusBarStyle {
        return (index % 2) == 0 ? .default : .lightContent
    }

    func tabBar(_ tabBar: AZTabBarController, shouldLongClickForIndex index: Int) -> Bool {
        return true//index != 2 && index != 3
    }

    func tabBar(_ tabBar: AZTabBarController, shouldAnimateButtonInteractionAtIndex index: Int) -> Bool {
        return false
    }

    func tabBar(_ tabBar: AZTabBarController, didMoveToTabAtIndex index: Int) {
    }

    func tabBar(_ tabBar: AZTabBarController, didSelectTabAtIndex index: Int) {
    }

    func tabBar(_ tabBar: AZTabBarController, willMoveToTabAtIndex index: Int) {
    }

    func tabBar(_ tabBar: AZTabBarController, didLongClickTabAtIndex index: Int) {
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    @IBAction func logOutClicked(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: R.string.localizable.doYouWantToLogOut(),
                                      preferredStyle: UIAlertControllerStyle.alert)

        let okAction = UIAlertAction(title: R.string.localizable.oK(), style: UIAlertActionStyle.destructive) { _ in
            if Auth.auth().currentUser != nil {
                do {
                    try Auth.auth().signOut()
                    let vc = R.storyboard.main.login()
                    self.show(vc!, sender: sender)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: R.string.localizable.cancel(),
                                      style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
