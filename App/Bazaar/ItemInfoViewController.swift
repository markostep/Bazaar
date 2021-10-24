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
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var itemPicView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemDescriptionTextView: UITextView!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    
    static var storeItemName: String!
    static var storeItemDescription: String!
    static var storeRetailer: String!
    static var storePoints: Float!
    static var storeScore: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        let storage = Storage.storage()
        let ref = Database.database().reference().child("Users").child("\(Auth.auth().currentUser!.uid)").child("Purchases").child("\(PurchaseListViewController.storeTappedOnList)")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                if let childSnapshot = snapshot.value as? [String : AnyObject]
                     {
                    let pathReference = storage.reference(withPath: "images/navyshirt.jpeg")
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
                    
                    self.itemDescriptionTextView.text = "\(childSnapshot["description"] as! String)"
                    ItemInfoViewController.setStoreRetailer(store: "\(childSnapshot["retailer"] as! String)")
                    ItemInfoViewController.setStoreItemName(store: "\(childSnapshot["productName"] as! String)")
                    ItemInfoViewController.setStoreItemDescription(store: "\(childSnapshot["description"] as! String)")
                    let points = (childSnapshot["points"] as! NSNumber)
                    ItemInfoViewController.setStorePoints(store: points.floatValue)
                    let score = (childSnapshot["score"] as! Int)
                    ItemInfoViewController.setStoreScore(store: score)
                    self.priceLabel.text = "Price: $\(childSnapshot["price"] as! Double)"
                    self.itemNameLabel.text = "\(childSnapshot["productName"] as! String)"
                    self.quantityLabel.text = "Quantity: \(childSnapshot["quantity"] as! Int)"
                    self.productTypeLabel.text = "Type: \(childSnapshot["productType"] as! String)"
                }
            }
        }
        
        // Do any additional setup after loading the view.
        itemNameLabel.text = "\(PurchaseListViewController.storeTappedOnList)"
        
    }
    
    static func setStoreItemName(store: String) {
        storeItemName = store
    }
    
    static func setStoreItemDescription(store: String) {
        storeItemDescription = store
    }
    
    static func setStoreRetailer(store: String) {
        storeRetailer = store
    }
    
    static func setStorePoints(store: Float) {
        storePoints = store
    }
    
    static func setStoreScore(store: Int) {
        storeScore = store
    }
    
    
    
}
