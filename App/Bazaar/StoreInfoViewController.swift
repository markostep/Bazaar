//
//  StoreInfoViewController.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import UIKit
import Firebase
import FirebaseStorage

class StoreInfoViewController: UIViewController {
    
    @IBOutlet weak var storeLogoView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeLocationLabel: UILabel!
    @IBOutlet weak var storeTagsLabel: UILabel!
    @IBOutlet weak var storeDescriptionTextView: UITextView!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var qrButton: UIButton!
    var link = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var name = ""
        let ref = Database.database().reference().child("Stores").child("\(ShopListViewController.storeTappedOnList)")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                if let childSnapshot = snapshot.value as? [String : AnyObject]
                     {
                    let imgPath = (childSnapshot["Image"] as! String)
                    let storage = Storage.storage()
                    let pathReference = storage.reference(withPath: imgPath)
                    print(pathReference)
                    
                    pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                      if let error = error {
                        // Uh-oh, an error occurred!
                      } else {
                        // Data for "images/island.jpg" is returned

                        self.storeLogoView.image = UIImage(data: data!)
                      }
                    }
                    self.storeNameLabel.text = (childSnapshot["Name"] as! String)
                    self.storeLocationLabel.text = (childSnapshot["Location"] as! String)
                    self.link = childSnapshot["Link"] as! String
                    self.storeTagsLabel.text = (childSnapshot["Industry"] as! String)
                }
            }
        }
        
        
        // Do any additional setup after loading the view.
        storeNameLabel.text = "\(ShopListViewController.storeTappedOnList)"
    }
    
    @IBAction func websiteButtonPressed() {
        if UIApplication.shared.canOpenURL(NSURL(string: link)! as URL) {
            UIApplication.shared.open(NSURL(string: link)! as URL)
        }
    }
    
    
    
}
