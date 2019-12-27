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
    
//    @IBOutlet weak var facebookLoginButton: UIButton!
//    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var googleLoginIcon: UIButton!
    @IBOutlet weak var socialIconStack: UIStackView!
    
   @IBOutlet weak var cloud1: UIImageView!
    @IBOutlet weak var cloud2: UIImageView!
    @IBOutlet weak var cloud3: UIImageView!
    @IBOutlet weak var cloud4: UIImageView!
    
    var shouldAnimate = false
    override func viewWillAppear(_ animated: Bool) {
        if let status = UserDefaults.standard.value(forKey: "IS_LOGIN") as? Bool{
            if status {
                performSegue(withIdentifier: "ProfileView", sender: self)
            }
        }
//        googleLoginButton.center.x += view.bounds.width
//        googleLoginButton.center.x -= view.bounds.width
        socialIconStack.center.x  -= view.bounds.width
        
        
        //Setting alpha to clouds
        cloud1.alpha = 0.0
        cloud2.alpha = 0.0
        cloud3.alpha = 0.0
        cloud4.alpha = 0.0
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        //Calling animateTheClouds()
        animateTheClouds(cloud: cloud1)
        animateTheClouds(cloud: cloud2)
        animateTheClouds(cloud: cloud3)
        animateTheClouds(cloud: cloud4)
        
        if shouldAnimate { animateView() }
        
        
        shouldAnimate = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        googleLoginButton.addTarget(self, action: #selector(singInUsingGoogle(_:)), for: .touchUpInside)
        googleLoginIcon.addTarget(self, action: #selector(singInUsingGoogle(_:)), for: .touchUpInside)
        if !shouldAnimate { animateView() }
    }
    
    @IBAction func loginWithFacebook(_ sender: Any){
        loginToFacebook()
    }
    
    @objc func singInUsingGoogle(_ sender: UIButton){
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    //MARK: - Facebook Functions
    func updateSegueState () {
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
                
                print("Login Success: Access token = \(AccessToken.self)")
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
                                            let url = "https://graph.facebook.com/\(fbId)/picture?type=large"
                                            if let imageUrl = URL(string: url){
                                                let user = User(id: fbId, email: email, name: name, pictureUrl: imageUrl)
                                                let userValues = LoginStatus(status: true, name: name, imageUrl: imageUrl, loginSourc: "Facebook")
                                                self.setLoginStatusValues(userValues: userValues)
                                                self.performSegue(withIdentifier: "ProfileView", sender: user)
                                            }
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
        if let name = user.profile.name,
            let GId = user.userID,
            let email = user.profile.email,
            let imageUrl = user.profile.imageURL(withDimension: 250){
            let user = User(id: GId, email: email, name: name, pictureUrl: imageUrl)
            let userValues = LoginStatus(status: true, name: name, imageUrl: imageUrl, loginSourc: "Google")
            self.setLoginStatusValues(userValues: userValues)
            self.performSegue(withIdentifier: "ProfileView", sender: user)
        }
    }
    //MARK: - Helper Functions
    
    func setLoginStatusValues(userValues: LoginStatus){
        UserDefaults.standard.set(userValues.status, forKey: "IS_LOGIN")
        UserDefaults.standard.set(userValues.name, forKey: "NAME")
        UserDefaults.standard.set(userValues.imageUrl, forKey: "IMAGE_URL")
        UserDefaults.standard.set(userValues.loginSourc, forKey: "LOGIN_SOURCE")
        print("UserDefault.standerd values updated")
    }
    func animateView(){
        UIView.animate(withDuration: 1.2) {
//            self.facebookLoginButton.center.x -= self.view.bounds.width
//            self.googleLoginButton.center.x += self.view.bounds.width
        }
        UIView.animate(withDuration: 1.2) {
            self.socialIconStack.center.x += self.view.bounds.width
        }
        self.view.applyGradient(colours: [.yellow, .white, .cyan], locations: [0.0, 0.5, 1.0])
    }
    
    //function to add animation loop to clouds
       func animateTheClouds(cloud : UIImageView) {
           let cloudMovingSpeed = 60.0/view.frame.size.width
           let duration = (view.frame.size.width - cloud.frame.origin.x) * cloudMovingSpeed
           UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: .curveLinear, animations: {
               cloud.frame.origin.x = self.view.frame.size.width
               }, completion: {_ in
                   cloud.frame.origin.x = -cloud.frame.size.width
                   self.animateTheClouds(cloud: cloud)
           })
       }
    
    
}
