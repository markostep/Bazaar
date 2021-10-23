//
//  ProfileViewController.swift
//  Bazaar
//
//  Created by Ankit Mehta on 10/23/21.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        
        ref.child("Users/\(uid)/Name").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
          let userName = snapshot.value as? String ?? "Unknown";
        });
        ref.child("Users/\(uid)/Email").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
          let email = snapshot.value as? String ?? "Unknown";
        });
        nameLabel.text(userName)
        emailLabel.text(email)
        // Do any additional setup after loading the view.
    }
    

}

