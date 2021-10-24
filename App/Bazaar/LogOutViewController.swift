//
//  LogOutViewController.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import UIKit
import FirebaseAuthUI

class LogOutViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonPressed() {
        do {
          try Auth.auth().signOut()
        } catch let err {
          print(err)
        }
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

