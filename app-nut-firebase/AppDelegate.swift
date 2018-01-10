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
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

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

        //google
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        if Auth.auth().currentUser == nil {
            self.window?.rootViewController = R.storyboard.main.mainLoginNavigation()
        } else {
            self.window?.rootViewController = R.storyboard.main.mainTabBarNavigation()
        }
        return true
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log into Google: ", err)
            return
        }

        print("Successfully logged into Google", user)
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }

            guard let uid = user?.uid else { return }
            print("Successfully logged into Firebase with Google", uid)
            self.window?.rootViewController = R.storyboard.main.mainTabBarNavigation()
        })
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        let facebookLogin = SDKApplicationDelegate.shared.application(app, open: url, options: options)
        let twitterLogin = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        let googleLogin = GIDSignIn.sharedInstance()
            .handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return facebookLogin || twitterLogin || googleLogin
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
