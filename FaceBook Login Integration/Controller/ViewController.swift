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

class ViewController: UIViewController,GIDSignInDelegate{
    
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
        
        if let name = UserDefaults.standard.value(forKey: "NAME") as? String{
            
        }
        if let imageurl = UserDefaults.standard.value(forKey: "IMAGE_URL") as? String{
            
        }
        
        if let status = UserDefaults.standard.value(forKey: "IS_LOGIN") as? Bool{
            
        }
        googleLoginButton.addTarget(self, action: #selector(singInUsingGoogle(_:)), for: .touchUpInside)
        
    }
    
    @IBAction func loginWithFacebook(_ sender: Any){
        loginToFacebook()
    }
    
    @objc func singInUsingGoogle(_ sender: UIButton){
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func updateSegueState () {
        
        print("isSeguePending state didset performed")
        self.performSegue(withIdentifier: "ProfileView", sender: self)
    }
    
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
                                            let imageUrl = "https://graph.facebook.com/\(fbId)/picture?type=large"
                                            
                                            let user = User(id: fbId, email: email, name: name, pictureUrl: imageUrl)
                                            self.performSegue(withIdentifier: "ProfileView", sender: user)
                                            
                                            UserDefaults.standard.set(name, forKey: "NAME")
                                            UserDefaults.standard.set(imageUrl, forKey: "IMAGE_URL")
                                            UserDefaults.standard.set(true, forKey: "IS_LOGIN")
                                            
                                        } else {
                                            print("Data fetching fail")
                                        }
        }
        
        connection.start()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let user = sender as? User {
            if let controller = segue.destination as? ProfileViewController {
                controller.user = user
            }
        }
    }
    
    //MARK: - Google Functions
    
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
        
      //  let url = String(describing: user.profile.imageURL(withDimension: 100))
        var imageUrl = ""
        
        do {
            let url = user.profile.imageURL(withDimension: 250)
            let contents = try String(contentsOf: url!)
            imageUrl = contents
               print(contents)
           } catch {
               // contents could not be loaded
           }
        print(imageUrl)
        
        if let name = user.profile.name,
           let GId = user.userID,
           let email = user.profile.email{
            let user = User(id: GId, email: email, name: name, pictureUrl: imageUrl)
            self.performSegue(withIdentifier: "ProfileView", sender: user)
        }
        
        
        print("Downloading image")
        
        
    }
    
    
    
}



