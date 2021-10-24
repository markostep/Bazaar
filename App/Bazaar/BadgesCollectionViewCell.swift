//
//  BadgesCollectionViewCell.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import Foundation
import UIKit


class BadgesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BadgesCollectionViewCell"
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
}
