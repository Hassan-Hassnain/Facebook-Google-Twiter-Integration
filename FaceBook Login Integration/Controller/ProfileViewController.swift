//
//  ProfileViewController.swift
//  FaceBook Login Integration
//
//  Created by Usama Sadiq on 12/23/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import UIKit
import FacebookLogin
import GoogleSignIn


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNaem: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileNaem.text = User.name
        if let image = User.picture {
            profileImage.image = image
        }else {
            print(" User.picture is nil")
        }
        
        
    }
    @IBAction func backButton(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance()?.signOut()
        let manager = LoginManager()
        manager.logOut()
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        
        print("User Disconnected")
        
    }
}
