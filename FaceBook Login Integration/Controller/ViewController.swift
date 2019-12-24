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
    
    var isSeguePending: Int = 0 {
        didSet{
            updateSegueState()
        }
    }
    
   // var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleLoginButton.addTarget(self, action: #selector(singInUsingGoogle(_:)), for: .touchUpInside)
        
    }

    @IBAction func loginWithFacebook(_ sender: Any){
        User.restParameters()
        loginToFacebook()
    }
    
    @objc func singInUsingGoogle(_ sender: UIButton){
        User.restParameters()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func updateSegueState () {
        
        print("isSeguePending state didset performed")
        self.performSegue(withIdentifier: "ProfileView", sender: self)
    }
    
}
    
    
    
