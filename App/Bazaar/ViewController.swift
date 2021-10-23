//
//  ViewController.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/22/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SocialFeedTableViewCell.identifier, for: indexPath) as? SocialFeedTableViewCell
        else { return UITableViewCell() }
        
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    

}

