//
//  PurchaseListViewController.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import UIKit
import Firebase
import FirebaseAuth

class PurchaseListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {
    
    
    static var storeTappedOnList = String()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseListTableViewCell.identifier, for: indexPath) as? PurchaseListTableViewCell
        else { return UITableViewCell() }
        
        //cell.storeNameLabel.text = "Store Name \(indexPath[1] + 1)"
        //cell.itemNameLabel.text = "Item Name \(indexPath[1] + 1)"
        
        let ref = Database.database().reference().child("Users").child("\(Auth.auth().currentUser!.uid)").child("Purchases").child("\(filteredData[indexPath.row])")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                if let childSnapshot = snapshot.value as? [String : AnyObject]
                     {
                    cell.storeNameLabel.text = (childSnapshot["retailer"] as! String)
                    cell.itemNameLabel.text = "\((childSnapshot["productName"] as! String))"
                }
            }
        }
        
        return cell
        
    }
    
    
    @IBOutlet var tableView: UITableView!
    var filteredData: [String]!
    var data = ["No stores yet available!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.showsVerticalScrollIndicator = false
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        let ref = Database.database().reference().child("Users").child("\(Auth.auth().currentUser!.uid )").child("Purchases")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                let array = snapshot.children.allObjects
                self.data.removeAll()
                for obj in array {
                    let snapshot:DataSnapshot = obj as! DataSnapshot
                    if let childSnapshot = snapshot.value as? [String : AnyObject]
                         {
                        self.data.append(childSnapshot["productId"] as! String)
                        
                    }
                }
            }
            self.filteredData = self.data
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
        storeTappedOnList = store
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let targetStoryboard = storyboard?.instantiateViewController(identifier: "ItemInfoPage")
        else { return }
        
        PurchaseListViewController.setStoreTappedOnList(store: filteredData[indexPath.row])
        //MapViewController.setMarkerTappedOnMap(marker: marker)
        //MapViewController.setTappedFrom(1)

        //performSegue(withIdentifier: subSetting.segueID, sender: self)
        navigationController?.pushViewController(targetStoryboard, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    

}
