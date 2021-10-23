//
//  SocialFeedTableViewCell.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/22/21.
//
import UIKit

class SocialFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var goToMapButton: UIButton!
    @IBOutlet weak var distLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    //@IBOutlet weak var circleImage: UIImageView!

    var likedState = false
    var likedAmount = 0
    

    static let identifier = "SocialFeedTableViewCell"



}

