//
//  Google Extension.swift
//  FaceBook Login Integration
//
//  Created by Usama Sadiq on 12/24/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import Foundation
import GoogleSignIn


//MARK: - Google Functions

extension ViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        //        let userId = user.userID                  // For client-side use only!
        //        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        //        let givenName = user.profile.givenName
        //        let familyName = user.profile.familyName
        //        let email = user.profile.email
        // ...
        if let fullName = fullName{
            User.name = fullName
        }
        
        print("Downloading image")
        
        
         let url = user.profile.imageURL(withDimension: 250)
            self.downloadImage(from: url!)
        imageView.image = User.picture
        
        performSegue(withIdentifier: "ProfileView", sender: self)
    }
   
    
    
    
}
