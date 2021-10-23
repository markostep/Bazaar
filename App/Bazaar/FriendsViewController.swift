//
//  ShopListViewController.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import UIKit
import Firebase
import FirebaseAuth

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {
    
    
    
    
    static var storeTappedOnList = Int()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier, for: indexPath) as? FriendsTableViewCell
        else { return UITableViewCell() }
        
        
        let name = "john"
        cell.name.text = "\(name)"
        
        return cell
        
    }
    
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child("Users").child("\(Auth.auth().currentUser?.uid)").child("Friends")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                let array = snapshot.children.allObjects
                    print(array)
            }
        }
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
