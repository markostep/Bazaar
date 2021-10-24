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

    static var friendsTappedOnList = String()

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    @objc func oneTapped(_ sender: Any?) {
        print("Decline")
    }
    
    @objc func twoTapped(_ sender: Any?) {
        print("Accept")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier, for: indexPath) as? FriendsTableViewCell
        else { return UITableViewCell() }
        let uid = Auth.auth().currentUser?.uid as! String
        
        let ref = Database.database().reference().child("Users/\(uid)/Friends").child("\(filteredData[indexPath.row])")
        
        print(filteredData[indexPath.row])
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                if let childSnapshot = snapshot.value as? [String : AnyObject]
                     {
                    cell.name.text = (childSnapshot["Name"] as! String)
                    if (childSnapshot["Status"] as! String == "Accepted") {
                        
                        cell.accept.isHidden = true
                        cell.decline.isHidden = true
                    } else {
                        cell.decline.addTarget(self, action: #selector(FriendsViewController.oneTapped(_:)), for: .touchUpInside)

                        cell.accept.addTarget(self, action: #selector(FriendsViewController.twoTapped(_:)), for: .touchUpInside)

                        cell.accept.isHidden = false
                        cell.decline.isHidden = false
                    }
                }
            }
        }
        
        //cell.storeNameLabel.text = filteredData[indexPath.row]
        
        return cell
        
    }
    
    
    @IBOutlet var tableView: UITableView!
    var filteredData: [String]!
    var data = ["No stores yet available!"]
    var data2 = ["No stores yet available!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        self.tableView.showsVerticalScrollIndicator = false
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        
        let uid = Auth.auth().currentUser?.uid as! String
        
        let ref = Database.database().reference().child("Users/\(uid)/Friends")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                let array = snapshot.children.allObjects
                self.data.removeAll()
                self.data2.removeAll()
                for obj in array {
                    let snapshot:DataSnapshot = obj as! DataSnapshot
                    if let childSnapshot = snapshot.value as? [String : AnyObject]
                         {
                        self.data.append(childSnapshot["ID"] as! String)
                    }
                }
            }
            self.filteredData = self.data
            print(self.data)
            self.tableView.reloadData()
        }
        
        filteredData = data
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
    
    static func setStoreTappedOnList(store: String) {
        friendsTappedOnList = store
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let targetStoryboard = storyboard?.instantiateViewController(identifier: "StoreInfoPage")
        else { return }
        
        ShopListViewController.setStoreTappedOnList(store: filteredData[indexPath.row])
        //MapViewController.setMarkerTappedOnMap(marker: marker)
        //MapViewController.setTappedFrom(1)

        //performSegue(withIdentifier: subSetting.segueID, sender: self)
        navigationController?.pushViewController(targetStoryboard, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
