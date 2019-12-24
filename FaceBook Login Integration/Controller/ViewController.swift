//
//  ViewController.swift
//  FaceBook Login Integration
//
//  Created by Usama Sadiq on 12/22/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn

class ViewController: UIViewController{
    
    
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
   // var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleLoginButton.addTarget(self, action: #selector(singInUsingGoogle(_:)), for: .touchUpInside)
        
    }
    
    @IBAction func loginWithFacebook(_ sender: Any){
        loginToFacebook()
        fetchProfileData()
    }
    
    @objc func singInUsingGoogle(_ sender: UIButton){
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
}
    
    
    
