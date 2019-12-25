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
    
    override func viewWillAppear(_ animated: Bool) {
        profileImage.center.y -= view.bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 1.2) {
                   self.profileImage.center.y += self.view.bounds.height
               }
        if let user = self.user {
            profileNaem.text = user.name
            profileImage.sd_setImage(with: user.pictureUrl, completed: nil)
        } else {
            let data = userData()
            profileNaem.text = data.1
            profileImage.sd_setImage(with: data.2, completed: nil)
            print("User already logged in via \(data.3)")
        }
    }
    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        
        GIDSignIn.sharedInstance()?.signOut()
        
        let manager = LoginManager()
        manager.logOut()
        
        UserDefaults.standard.set(false, forKey: "IS_LOGIN")
    }
    //MARK: - Helping function
    
    
    func userData() -> (Bool,String,URL,String) {
        
        print("getUserDefualtValue function called")
        let status = UserDefaults.standard.value(forKey: "IS_LOGIN") as? Bool
        let name = UserDefaults.standard.value(forKey: "NAME") as? String
         let imageUrl = UserDefaults.standard.url(forKey: "IMAGE_URL")
         let source = UserDefaults.standard.value(forKey: "LOGIN_SOURCE") as? String
        
        if let status = status, let name = name, let imageUrl = imageUrl, let source = source{
             print("This is true part")
            return (status,name,imageUrl,source)
        } else {
            return (false,"",URL(string: ".")!,"")
            
        }
    }
    
}


