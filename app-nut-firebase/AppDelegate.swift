//
//  AppDelegate.swift
//  app-nut-firebase
//
//  Created by Jiraporn Praneet on 7/11/2560 BE.
//  Copyright © 2560 Jiraporn Praneet. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookCore
import TwitterKit
import TwitterCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //firebase
        FirebaseApp.configure()
        
        //facebook
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //twitter
        TWTRTwitter.sharedInstance().start(withConsumerKey: "9pa8cilfXFUuCzX7lzh3bXWSM",
                                           consumerSecret: "DmU8hMrTnikqS5c6InFdROQSO2lTIdovv8URzfVkk5Imb6kHkj")
        if Auth.auth().currentUser == nil {
            self.window?.rootViewController = R.storyboard.main.mainLoginNavigation()
        } else {
            self.window?.rootViewController = R.storyboard.main.mainTabBarNavigation()
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        let facebookLogin = SDKApplicationDelegate.shared.application(app, open: url, options: options)
        let twitterLogin = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        return facebookLogin || twitterLogin
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
