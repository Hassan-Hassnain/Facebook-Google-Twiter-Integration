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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        printProfile()
    }
    
    @IBAction func loginWithFacebook(_ sender: Any){
        self.loginToFacebook()
        self.fetchProfileData()
        
        
        
    }
    
    
    func loginSuccessful(){
        print("Access token = \(AccessToken.self)")
        self.printProfile()
        
        self.performSegue(withIdentifier: "ProfileView", sender: self)
    }
    
    func printProfile()
    {
        print(User.id)
        print(User.email)
        print(User.name)
    }
    
}

//MARK: - Facebook Functions
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
                self.loginSuccessful()
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
                                            
                                            print(fbId)
                                            if fbId != "" {
                                                let url = URL(string: "https://graph.facebook.com/\(fbId)/picture?type=large")
                                                self.downloadImage(from: url!)
                                                
                                            } else {
                                                
                                            }
                                            //  https://graph.facebook.com/3883473975011742/picture?type=large
                                            
                                            //self.printProfile()
                                        } else {
                                            print("Data fetching fail")
                                        }
        }
        connection.start()
    }
    
    func readUserEvents() {
        let request = GraphRequest(graphPath: "/me/events",
                                   parameters: [ "fields": "data, description" ],
                                   httpMethod: .get)
        request.start { [weak self] _, result, error in
            //self?.presentAlertController(result: result, error: error)
        }
    }
    
    func readUserFriendList() {
        let request = GraphRequest(graphPath: "/me/friends",
                                   parameters: [ "fields": "data" ],
                                   httpMethod: .get)
        request.start { [weak self] _, result, error in
            //self?.presentAlertController(result: result, error: error)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                
                User.picture = UIImage(data: data)
                
            }
        }
    }
    
}


