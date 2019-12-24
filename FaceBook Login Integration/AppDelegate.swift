//
//  AppDelegate.swift
//  FaceBook Login Integration
//
//  Created by Usama Sadiq on 12/22/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import UIKit
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    
    
    
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
    // Initialize sign-in
    GIDSignIn.sharedInstance().clientID = "714101398744-9nap7lud85ejqpr1udoolqen0sn8vph2.apps.googleusercontent.com"
    //GIDSignIn.sharedInstance().delegate = self
    
        return true
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
              print("In AppDelegate")
          }

          @available(iOS 9.0, *)
          func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
          }
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
//MARK:  Google
    
//   func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//       print("In AppDelegate")
//   }
//
//   @available(iOS 9.0, *)
//   func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//     return GIDSignIn.sharedInstance().handle(url)
//   }
////
////func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
////          withError error: Error!) {
////
////  if let error = error {
////    if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
////      print("The user has not signed in before or they have since signed out.")
////    } else {
////      print("\(error.localizedDescription)")
////    }
////    return
////  }
////  // Perform any operations on signed in user here.
////  let userId = user.userID                  // For client-side use only!
////  let idToken = user.authentication.idToken // Safe to send to the server
////  let fullName = user.profile.name
////  let givenName = user.profile.givenName
////  let familyName = user.profile.familyName
////  let email = user.profile.email
////  // ...
////
////    print("did Sign in for user")
////}
////
////func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
////          withError error: Error!) {
////  // Perform any operations when the user disconnects from app here.
////  // ...
////
////    print("didDisconnectWtith user")
////}
////func signInWillDispatch(_ signIn: GIDSignIn!, error: Error!) {
////}
////
////// Present a view that prompts the user to sign in with Google
////
//
//

}

