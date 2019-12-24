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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleLoginButton.addTarget(self, action: #selector(singInUsingGoogle(_:)), for: .touchUpInside)
        //printProfile()
    }
    
    @IBAction func loginWithFacebook(_ sender: Any){
        self.loginToFacebook()
        self.fetchProfileData()
    }
    
    @objc func singInUsingGoogle(_ sender: UIButton){
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    func printProfile()
    {
        print(User.id)
        print(User.email)
        print(User.name)
    }
    
}


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
        
 
        if let url = user.profile.imageURL(withDimension: 120){
            print(url)
            UIImage.loadFrom(url: url) { image in
                User.picture = image
                print("Image downloaded")
            }
        } else {
            print("Image download failed")
        }
        
        print("did Sign in for user")
        performSegue(withIdentifier: "ProfileView", sender: self)
    }
    
}



public extension UIImage {
    
    static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
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
                self.FacebookLoginSuccessful()            }
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
    
    func FacebookLoginSuccessful(){
        print("Access token = \(AccessToken.self)")
        self.printProfile()
        
        self.performSegue(withIdentifier: "ProfileView", sender: self)
    }
    
}


