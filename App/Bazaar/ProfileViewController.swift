//
//  ProfileViewController.swift
//  Bazaar
//
//  Created by Ankit Mehta on 10/23/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarLabel: UILabel!
    @IBOutlet weak var redeemButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference().child("Users").child("\(Auth.auth().currentUser!.uid )")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                if let childSnapshot = snapshot.value as? [String : AnyObject]
                     {
                    let name = "\(childSnapshot["Name"] as! String)"
                    let email = "\(childSnapshot["Email"] as! String)"
                    let area = "📍\(childSnapshot["Area"] as! String)"
                    //let progress = (childSnapshot["Points"] as! NSNumber)
                    //let progressFloat = progress.floatValue
                    self.emailLabel.text = email
                    self.nameLabel.text = name
                    self.areaLabel.text = area
                    //self.progressBar.progress = progressFloat / 1000.0
                    //self.progressBarLabel.text = "\(progressFloat)/1000 points"
                    self.progressBar.transform = self.progressBar.transform.scaledBy(x: 1, y: 9)
                    self.progressBar.layer.cornerRadius = 10
                    self.progressBar.clipsToBounds = true
                    self.progressBar.layer.sublayers![1].cornerRadius = 10
                    self.progressBar.subviews[1].clipsToBounds = true
                }
            }
        }
        
        ref.observe(.value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                if let childSnapshot = snapshot.value as? [String : AnyObject]
                     {
                    let progress = (childSnapshot["Points"] as! NSNumber)
                    let progressFloat = progress.floatValue
                    self.progressBar.progress = progressFloat / 1000.0
                    self.progressBarLabel.text = "\(progressFloat)/1000 points"
                    
                    if self.progressBar.progress >= 1 {
                        self.progressBar.progressTintColor = UIColor.systemGreen
                        self.redeemButton.alpha = 1
                    } else {
                        self.progressBar.progressTintColor = UIColor.systemBlue
                        self.redeemButton.alpha = 0
                    }
                }
            }
        }
        let storage = Storage.storage()
        let uid = Auth.auth().currentUser?.uid as! String

        let pathReference = storage.reference(withPath: "users/\(uid).jpg")
        print(pathReference)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        pathReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned

            self.profilePic.image = UIImage(data: data!)
          }
        }
    }
    
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBAction func logoutButtonPressed() {
        do {
          try Auth.auth().signOut()
        } catch let err {
          print(err)
        }
      }
    

}

