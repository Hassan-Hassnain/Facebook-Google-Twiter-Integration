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

class ViewController: UIViewController {
    
    //var me = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginWithFacebook(_ sender: Any){
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result{
            case .cancelled:
                print("User cancelled login process")
                break
            case .failed(let error):
                print("Login failed with error = \(error.localizedDescription)")
                break
            case .success(let granted, let declined, let token):
                print("Access token = \(AccessToken.self)")
                
                self.fetchProfileData()
                
            }
        }
        self.p()
        
    }

    func fetchProfileData(){
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields":"email"])) { httpResponse, result, error   in
            if error != nil {
                NSLog(error.debugDescription)
                return
            }

            // Handle vars
            if let result = result as? [String:String],
                let email: String = result["email"],
                let fbId: String = result["id"]
           // let name: String = result["name"]
            {
                User.id = fbId
                User.email = email
               // User.name = name
                    print(fbId)
                print(email)
            } else {
                print("Data fetching fail")
            }

        }
        connection.start()
        p()
    }
    
    
    func p()
    {
        print(User.id)
        print(User.email)
        print(User.name)
    }
    
}

