//
//  ItemInfoViewController.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import UIKit
import FirebaseAuth
import Firebase

class ItemInfoViewController: UIViewController {
    
    @IBOutlet weak var itemPicView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemDescriptionTextView: UITextView!
    @IBOutlet weak var websiteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storage = Storage.storage()
        let uid = Auth.auth().currentUser?.uid

        let pathReference = storage.reference(withPath: "images/324AFE96-A68F-4104-89D4-07BDD68E7125_4_5005_c.jpeg")
        print(pathReference)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned

            self.itemPicView.image = UIImage(data: data!)
          }
        }
        
        // Do any additional setup after loading the view.
        itemNameLabel.text = "Item Name \(PurchaseListViewController.storeTappedOnList + 1)"
        
    }
    
    
    
}
