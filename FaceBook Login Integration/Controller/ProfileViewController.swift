//
//  ProfileViewController.swift
//  FaceBook Login Integration
//
//  Created by Usama Sadiq on 12/23/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import UIKit
import FacebookLogin

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNaem: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileNaem.text = User.name
        profileImage.image = User.picture
    }
    @IBAction func backButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
        let manager = LoginManager()
        manager.logOut()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
