//
//  SocialFeedTableViewCell.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/22/21.
//
import UIKit
import FirebaseAuth
import Firebase
class SocialFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var goToMapButton: UIButton!
    @IBOutlet weak var distLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var mediaView: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timePostedLabel: UILabel!
    //@IBOutlet weak var circleImage: UIImageView!

    var likedState = false
    var likedAmount = 0
    var postId: String!
    

    static let identifier = "SocialFeedTableViewCell"
    
    @IBAction func likeButtonTapped() {
        if likedState {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            likeButton.imageView?.tintColor = UIColor.systemGray
            likedState = false
            likedAmount -= 1
            if likedAmount != 0 {
                likeButton.setTitle(" Likes • \(likedAmount)", for: .normal)
            } else {
                likeButton.setTitle(" Likes", for: .normal)
            }
            likeButton.setTitleColor(UIColor.systemGray, for: .normal)
            let ref = Database.database().reference()
            ref.child("Users").child("\( Auth.auth().currentUser!.uid)" ).child("liked").child(postId).removeValue()
        }else {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            likeButton.imageView?.tintColor = UIColor.black
            likedState = true
            likedAmount += 1
            likeButton.setTitle(" Likes • \(likedAmount)", for: .normal)
            likeButton.setTitleColor(UIColor.black, for: .normal)
            let ref = Database.database().reference()
            //let userDictionary = [ postId : postId ] as [String : Any]
            ref.child("Users").child("\( Auth.auth().currentUser?.uid ?? "No userid value!")" ).child("liked").child(postId).setValue(postId)
        }
        let ref = Database.database().reference().child("Posts").child(postId).child("likes")
        ref.setValue(likedAmount)
    }



}

