//
//  StoreInfoViewController.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import UIKit

class StoreInfoViewController: UIViewController {
    
    @IBOutlet weak var storeLogoView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeLocationLabel: UILabel!
    @IBOutlet weak var storeTagsLabel: UILabel!
    @IBOutlet weak var storeDescriptionTextView: UITextView!
    @IBOutlet weak var websiteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        storeNameLabel.text = "Store Name \(ShopListViewController.storeTappedOnList + 1)"
    }
    
    @IBAction func websiteButtonPressed() {
        if UIApplication.shared.canOpenURL(NSURL(string: "https://www.linkedin.com/in/poojan-raval-221243197/")! as URL) {
            UIApplication.shared.open(NSURL(string: "https://www.linkedin.com/in/poojan-raval-221243197/")! as URL)
        }
    }
    
    
}
