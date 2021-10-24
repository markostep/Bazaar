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
        return filteredData.count
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
        
        var image: UIImage!
        var imageSet = false
        
        let ref = Database.database().reference().child("Posts").child("\(filteredData[indexPath.row])")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                if let childSnapshot = snapshot.value as? [String : AnyObject]
                     {
                    cell.typeLabel.text = (childSnapshot["itemName"] as! String)
                    cell.distLabel.text = (childSnapshot["description"] as! String)
                    cell.descriptionTextView.text = (childSnapshot["caption"] as! String)
                    cell.likedAmount = (childSnapshot["likes"] as! Int)
                    cell.timeLabel.text = (childSnapshot["retailer"] as! String)
                    
                    let imgPath = (childSnapshot["image"] as! String)
                    let storage = Storage.storage()
                    let pathReference = storage.reference(withPath: imgPath)
                    print(pathReference)
                    
                    pathReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
                      if let error = error {
                        // Uh-oh, an error occurred!
                          print("error occured image")
                      } else {
                        // Data for "images/island.jpg" is returned

                          cell.mediaView.image = UIImage(data: data!)
                          image = cell.mediaView.image
                          imageSet = true
                      }
                    }
                }
            }
        }
        if (!imageSet) {
            image = UIImage(named: "pickapicture")
        }
        
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
        refresh()
    }
    
    func showLoginVC() {
        let authUI = FUIAuth.defaultAuthUI()
        let providers: [FUIAuthProvider] = [FUIEmailAuth()]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        authViewController.modalPresentationStyle = .fullScreen
        /*authViewController.navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor.systemBlue
        authViewController.navigationBar.standardAppearance.backgroundColor = UIColor.systemBlue
        authViewController.navigationBar.tintColor = UIColor.systemBlue
        authViewController.navigationBar.barTintColor = UIColor.systemBlue*/
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
        
        refresh()
        
        filteredData = data
    }
    
    var filteredData: [String]!
    var data = ["No stores yet available!"]
    
    func refresh() {
        let ref = Database.database().reference().child("Posts")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                let array = snapshot.children.allObjects
                self.data.removeAll()
                for obj in array {
                    let snapshot:DataSnapshot = obj as! DataSnapshot
                    if let childSnapshot = snapshot.value as? [String : AnyObject]
                         {
                        self.data.append(childSnapshot["itemID"] as! String)
                        
                    }
                }
            }
            self.filteredData = self.data
            self.tableView.reloadData()
        }
    }

    @objc func refresh(_ refreshControl: UIRefreshControl) {
        //DispatchQueue.global().async {
            self.refresh()
            refreshControl.endRefreshing()
            /*MarkerManager.shared.refreshMarkers {
                refreshControl.endRefreshing()
                self.markers = MarkerManager.shared.markers
                self.selectViewDidDisappearAction()
                self.refreshLiked()
                self.tableView.reloadData()
                NotificationCenter.default.post(name: MapViewController.reloadMapNotification, object: nil)
            }*/
        //}
    }
    
    
    
    

    
    

}

