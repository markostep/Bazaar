//
//  ShopListViewController.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import UIKit

class ShopListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {
    
    
    static var storeTappedOnList = Int()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShopListTableViewCell.identifier, for: indexPath) as? ShopListTableViewCell
        else { return UITableViewCell() }
        
        cell.storeNameLabel.text = "Store Name \(indexPath[1] + 1)"
        
        return cell
        
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
    
    static func setStoreTappedOnList(store: Int) {
        storeTappedOnList = store
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let targetStoryboard = storyboard?.instantiateViewController(identifier: "StoreInfoPage")
        else { return }
        
        let store = indexPath[1]
        ShopListViewController.setStoreTappedOnList(store: store)
        //MapViewController.setMarkerTappedOnMap(marker: marker)
        //MapViewController.setTappedFrom(1)

        //performSegue(withIdentifier: subSetting.segueID, sender: self)
        navigationController?.pushViewController(targetStoryboard, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    

}
