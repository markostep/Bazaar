
import UIKit
import FirebaseAuth
class FriendsTableViewCell: UITableViewCell {
    
    static let identifier = "FriendsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FriendsTableViewCell",
                     bundle: nil)
    }
    
    @IBOutlet var name: UILabel!
    @IBOutlet var accept: UIButton!
    @IBOutlet var decline: UIButton!
    
        
    @IBAction func acceptButtonPressed() {
        updateFriends(accepted: true)
    }
    
    @IBAction func declineButtonPressed() {
        updateFriends(accepted: false)
    }
    
    

}
private extension FriendsTableViewCell {
    func updateFriends(accepted: Bool) {
        if accepted {
            print("True")
            self.accept.isHidden = true
            self.decline.isHidden = true
        } else {
            print("False")
            self.accept.isHidden = true
            self.decline.isHidden = true
        }
        
    }
}
