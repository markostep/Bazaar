//
//  ViewController.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/22/21.
//

import UIKit
import FirebaseAuthUI
import Firebase
import FirebaseGoogleAuthUI
import FirebaseEmailAuthUI

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SocialFeedTableViewCell.identifier, for: indexPath) as? SocialFeedTableViewCell
        else { return UITableViewCell() }
        
        cell.descriptionTextView.isEditable = false
        
        let likedAmount = 0;
        
        cell.likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        cell.likeButton.imageView?.tintColor = UIColor.systemGray
        cell.likeButton.setTitle(" Helpful • \(likedAmount)", for: .normal)
        cell.typeLabel.text = "Clothes OMG"
        
        let image = UIImage(named: "poojywoojy.jpeg")
        let ratio = (image?.size.width)! / (image?.size.height)!
        let newHeight = cell.mediaView.frame.width / ratio
        //let width = image?.size.width
        //let height = image?.size.height
        //mediaCell.mediaView.clipsToBounds = true
        //mediaCell.mediaView.contentMode = .center
        //mediaCell.mediaView.contentMode = .scaleAspectFit
        //mediaCell.mediaView.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        cell.heightConstraint.constant = newHeight
        cell.mediaView.layoutIfNeeded()
        
        cell.mediaView.image = image
        
        return cell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
        if user == nil {
            self.showLoginVC()
        } else {
            let ref = Database.database().reference()
            ref.child("Users").child("\( Auth.auth().currentUser?.uid ?? "No userid value!")" ).child("Name").setValue("\( Auth.auth().currentUser?.displayName ?? "No name!")" )
            ref.child("Users").child("\( Auth.auth().currentUser?.uid ?? "No userid value!")" ).child("Email").setValue("\(Auth.auth().currentUser?.email ?? "No name!")" )
            ref.child("Users").child("\( Auth.auth().currentUser?.uid ?? "No userid value!")" ).child("Area").setValue("Atlanta, GA")
        }
        }
    }
    
    func showLoginVC() {
        let authUI = FUIAuth.defaultAuthUI()
        let providers: [FUIAuthProvider] = [FUIEmailAuth(), FUIGoogleAuth()]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        authViewController.modalPresentationStyle = .fullScreen
        authViewController.navigationBar.tintColor = UIColor.white
        authViewController.navigationBar.barTintColor = UIColor.init(red: 254/255, green: 70/255, blue: 70/255, alpha: 1)
        self.present(authViewController, animated: true, completion: nil)
    }
    
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.showsVerticalScrollIndicator = false
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }

    @objc func refresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.global().async {
            refreshControl.endRefreshing()
            /*MarkerManager.shared.refreshMarkers {
                refreshControl.endRefreshing()
                self.markers = MarkerManager.shared.markers
                self.selectViewDidDisappearAction()
                self.refreshLiked()
                self.tableView.reloadData()
                NotificationCenter.default.post(name: MapViewController.reloadMapNotification, object: nil)
            }*/
        }
    }
    
    
    
    

    
    

}

