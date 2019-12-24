//
//  Image Downloading .swift
//  FaceBook Login Integration
//
//  Created by Usama Sadiq on 12/24/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import Foundation
import UIKit

//fuctions to download and and convert image as UIImage
extension ViewController {
    //MARK: - Functions to download image from URL
        
        func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
        
        func downloadImage(from url: URL) {
            
            var profileImage = UIImage()
            print(url)
            
            print("Download Started")
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() {
                    
                    profileImage = UIImage(data: data)!
                    
                    print("User.pictre = \(profileImage)")
                    User.picture = profileImage
                    self.imageView.image = profileImage
                    self.isSeguePending += 1
                }
            }
        }
        
    }

