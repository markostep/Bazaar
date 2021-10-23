//
//  ProfileViewController.swift
//  Bazaar
//
//  Created by Ankit Mehta on 10/23/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child("Users")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                let array = snapshot.children.allObjects
                for obj in array {
                    let snapshot:DataSnapshot = obj as! DataSnapshot
                    if let childSnapshot = snapshot.value as? [String : AnyObject]
                         {
                        let name = childSnapshot["Name"] as! String
                        let email = childSnapshot["Email"] as! String
                        print(name)
                        print(email)
                        self.emailLabel.text = email
                        self.nameLabel.text = name
                    }
                }
            }
        }
        
        /*ref.child("Users/\(Auth.auth().currentUser?.uid)/Name").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
          let userName = snapshot.value as? String ?? "Unknown";
            self.nameLabel.text = userName
        });
        ref.child("Users/\(Auth.auth().currentUser?.uid)/Email").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
          let email = snapshot.value as? String ?? "Unknown";
            self.emailLabel.text = email

        });*/
                // Do any additional setup after loading the view.
    }
    

}

