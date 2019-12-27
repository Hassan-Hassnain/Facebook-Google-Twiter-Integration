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
        
        self.view.applyGradient(colours: [.yellow, .white, .red], locations: [0.0, 0.5, 1.0])
        profileNaem.applyGradient(colours: [UIColor.green] )
        
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
        let status = UserDefaults.standard.value(forKey: "IS_LOGIN") as? Bool
        let name = UserDefaults.standard.value(forKey: "NAME") as? String
         let imageUrl = UserDefaults.standard.url(forKey: "IMAGE_URL")
         let source = UserDefaults.standard.value(forKey: "LOGIN_SOURCE") as? String
        
        if let status = status, let name = name, let imageUrl = imageUrl, let source = source{
            return (status,name,imageUrl,source)
        } else {
            return (false,"",URL(string: ".")!,"")
            
        }
    }
    
}

//MARK: - UIView Gradient Color

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

