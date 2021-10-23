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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child("Users").child("\(Auth.auth().currentUser!.uid )")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                if let childSnapshot = snapshot.value as? [String : AnyObject]
                     {
                    let name = childSnapshot["Name"] as! String
                    let email = childSnapshot["Email"] as! String
                    let area = childSnapshot["Area"] as! String
                    self.emailLabel.text = email
                    self.nameLabel.text = name
                    self.areaLabel.text = area
                }
            }
        }
        let storage = Storage.storage()
        let uid = Auth.auth().currentUser?.uid as! String

        let pathReference = storage.reference(withPath: "users/\(uid).jpg")
        print(pathReference)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned

            self.profilePic.image = UIImage(data: data!)
          }
        }
    }
    

}

