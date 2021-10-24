//
//  ShopListViewController.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import UIKit
import Firebase

class ShopListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    static var storeTappedOnList = String()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShopListTableViewCell.identifier, for: indexPath) as? ShopListTableViewCell
        else { return UITableViewCell() }
        
        let ref = Database.database().reference().child("Stores").child("\(filteredData[indexPath.row])")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                if let childSnapshot = snapshot.value as? [String : AnyObject]
                     {
                    cell.storeNameLabel.text = (childSnapshot["Name"] as! String)
                    cell.storeLocDescLabel.text = "📍\((childSnapshot["Location"] as! String))  🏠\((childSnapshot["Industry"] as! String))"
                }
            }
        }
        
        //cell.storeNameLabel.text = filteredData[indexPath.row]
        
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
        
        searchBar.delegate = self
        
        refresh()
        
        filteredData = data
    }
    
    func refresh() {
        let ref = Database.database().reference().child("Stores")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                let array = snapshot.children.allObjects
                self.data.removeAll()
                for obj in array {
                    let snapshot:DataSnapshot = obj as! DataSnapshot
                    if let childSnapshot = snapshot.value as? [String : AnyObject]
                         {
                        self.data.append(childSnapshot["Name"] as! String)
                        
                    }
                }
            }
            self.filteredData = self.data
            self.tableView.reloadData()
        }
    }

    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.refresh()
        refreshControl.endRefreshing()
        //DispatchQueue.global().async {
          //  refreshControl.endRefreshing()
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
    
    static func setStoreTappedOnList(store: String) {
        storeTappedOnList = store
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

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // When there is no text, filteredData is the same as the original data
            // When user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = searchText.isEmpty ? data : data.filter { (item: String) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            
            tableView.reloadData()
        }
    

}
