//
//  SettingsTableViewCell.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    static let identifier = "FriendsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FriendsTableViewCell",
                     bundle: nil)
    }
    
    @IBOutlet var name: UILabel!
    @IBOutlet var accept: UIButton!
    @IBOutlet var decline: UIButton!
    
    @IBAction func tappedAccept() {
        name.text = "changed"
        print("tapped")
    }
    @IBAction func tappedDecline() {
        print("tapped")
    }
    
    
    
    func configure(with title: String) {
        
    }



}
