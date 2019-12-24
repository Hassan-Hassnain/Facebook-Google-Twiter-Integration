//
//  Facebook.swift
//  FaceBook Login Integration
//
//  Created by Usama Sadiq on 12/24/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin

//Mark: - Facebook Methods

extension ViewController {
    
    func loginToFacebook (){
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result{
            case .cancelled:
                print("User cancelled login process")
                break
            case .failed(let error):
                print("Login failed with error = \(error.localizedDescription)")
                break
            case .success( _, _, _):
                                
                print("Access token = \(AccessToken.self)")
                self.fetchProfileData()
            }
        }
    }
    
    func fetchProfileData(){
        
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me",
                                    parameters: ["fields":"id, name, first_name, last_name, email"])) {
                                        httpResponse, result, error   in
                                        if error != nil {
                                            NSLog(error.debugDescription)
                                            return
                                        }
                                        // Handle vars
                                        if let result = result as? [String:String],
                                            let email: String = result["email"],
                                            let fbId: String = result["id"],
                                            let name: String = result["name"]
                                        {
                                            User.id = fbId
                                            User.email = email
                                            User.name = name
                                            let url = URL(string: "https://graph.facebook.com/\(fbId)/picture?type=large")
                                            self.downloadImage(from: url!)
                                            self.imageView.image = User.picture
                                        } else {
                                            print("Data fetching fail")
                                        }
        }
        connection.start()
    }
    
}
