//
//  SettingsTableViewCell.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let identifier = "SettingsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SettingsTableViewCell",
                     bundle: nil)
    }
    
    @IBOutlet var button: UIButton!
    
    @IBAction func tappedButton() {
        
    }
    
    func configure(with title: String) {
        button.setTitle(title, for: .normal)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        button.setTitleColor(.link, for: .normal)
        // Initialization code
    }

}
