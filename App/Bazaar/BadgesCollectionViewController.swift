//
//  BadgesCollectionView.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import UIKit
import Firebase

class BadgesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    static var storeTappedOnList = String()
    let margin: CGFloat = 10
    
    @IBOutlet weak var collectionView: UICollectionView!
    var filteredData: [String]!
    var data = ["No stores yet available!"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        self.collectionView.showsVerticalScrollIndicator = false

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
            self.collectionView.reloadData()
        }
        
        filteredData = data
        
        guard let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

            flowLayout.minimumInteritemSpacing = margin
            flowLayout.minimumLineSpacing = margin
            flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
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
        guard let targetStoryboard = storyboard?.instantiateViewController(identifier: "StoreInfoPage")
        else { return }
        
        ShopListViewController.setStoreTappedOnList(store: filteredData[indexPath.row])
        //MapViewController.setMarkerTappedOnMap(marker: marker)
        //MapViewController.setTappedFrom(1)

        //performSegue(withIdentifier: subSetting.segueID, sender: self)
        navigationController?.pushViewController(targetStoryboard, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BadgesCollectionViewCell.identifier, for: indexPath) as? BadgesCollectionViewCell
        else { return UICollectionViewCell() }
        var ref = Database.database().reference()
        
        if (indexPath.row == 0) {
            cell.badgeImageView.image = UIImage(named: "treehug.jpg")
            cell.badgeLabel.text = "Tree Hugger"
            
            ref = Database.database().reference().child("Users").child("\(Auth.auth().currentUser!.uid)").child("Badges").child("tree_hugger")
        } else if (indexPath.row == 1) {
            cell.badgeImageView.image = UIImage(named: "strongtogether.jpg")
            
            ref = Database.database().reference().child("Users").child("\(Auth.auth().currentUser!.uid)").child("Badges").child("stronger_together")
            cell.badgeLabel.text = "Strong Together"
        } else if (indexPath.row == 2) {
            cell.badgeImageView.image = UIImage(named: "planetsaver.jpg")
            
            ref = Database.database().reference().child("Users").child("\(Auth.auth().currentUser!.uid)").child("Badges").child("planet_saver")
            cell.badgeLabel.text = "Planet Saver"
        } else if (indexPath.row == 3) {
            cell.badgeImageView.image = UIImage(named: "clothes.jpg")
            
            ref = Database.database().reference().child("Users").child("\(Auth.auth().currentUser!.uid)").child("Badges").child("clothes_collector")
            cell.badgeLabel.text = "Clothes Collector"
        } else if (indexPath.row == 4) {
            cell.badgeImageView.image = UIImage(named: "bestfriends.jpg")
            
            ref = Database.database().reference().child("Users").child("\(Auth.auth().currentUser!.uid)").child("Badges").child("best_friends")
            cell.badgeLabel.text = "Best Friends"
        } else if (indexPath.row == 5) {
            cell.badgeImageView.image = UIImage(named: "bazaar.jpg")
            
            ref = Database.database().reference().child("Users").child("\(Auth.auth().currentUser!.uid)").child("Badges").child("going_bazaar")
            cell.badgeLabel.text = "Bazaar Award"
        }
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { return }
            if(snapshot.exists()) {
                if let childSnapshot = snapshot.value as? [String : AnyObject]
                     {
                    if (childSnapshot["achieved"] as! Bool) {
                        cell.blurView.alpha = 0
                    } else {
                        cell.blurView.alpha = 0.9
                    }
                    
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }

    
    
}
