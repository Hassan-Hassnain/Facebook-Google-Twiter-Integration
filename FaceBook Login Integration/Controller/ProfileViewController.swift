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
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNaem: UILabel!
    
    var user :User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = self.user {
            profileNaem.text = user.name
            profileImage.sd_setImage(with: user.pictureUrl, completed: nil)
        }
        savedValues()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance()?.signOut()
        let manager = LoginManager()
        manager.logOut()
        UserDefaults.standard.set(false, forKey: "IS_LOGIN")
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    func savedValues(){
        if let name = UserDefaults.standard.value(forKey: "NAME") as? String{
            print(name)
        }
        if let imageurl = UserDefaults.standard.value(forKey: "IMAGE_URL") as? String{
            print(imageurl)
        }
        
        if let status = UserDefaults.standard.value(forKey: "IS_LOGIN") as? Bool{
            print(status)
        }
    }
}





