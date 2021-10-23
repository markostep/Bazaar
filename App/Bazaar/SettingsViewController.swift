//
//  SettingsViewController.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    enum SubSetting: Int, CaseIterable {
        case account
        case readFromRing
        case writeToRing
        case help
        case about
        case logout
        
        var name: String {
            switch self {
            case .account:
                return "Account"
            case .readFromRing:
                return "Read from Ring"
            case .writeToRing:
                return "Write to Ring"
            case .help:
                return "Help"
            case .about:
                return "About"
            case .logout:
                return "Log Out"
            }
        }
        
        var identifier: String {
            switch self {
            case .account:
                return "accountpage"
            case .readFromRing:
                return "readpage"
            case .writeToRing:
                return "writepage"
            case .help:
                return "helppage"
            case .about:
                return "aboutpage"
            case .logout:
                return "logoutpage"
            }
        }
        
        var segueID: String {
            switch self {
            case .account:
                return "accountSegue"
            case .readFromRing:
                return "readpageSegue"
            case .writeToRing:
                return "writepageSegue"
            case .help:
                return "helppageSegue"
            case .about:
                return "aboutpageSegue"
            case .logout:
                return "logoutpageSegue"
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
//        tableView.register(SettingsTableViewCell.nib(), forCellReuseIdentifier: "SettingsViewController")
        tableView.dataSource = self
        self.tableView.rowHeight = 44;
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SubSetting.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell
        else { return UITableViewCell() }
        
        let subSetting = SubSetting(rawValue: indexPath.row) ?? .account
        cell.textLabel?.text = subSetting.name
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.backgroundColor = UIColor.init(red: 44/255, green: 51/255, blue: 59/255, alpha: 1)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let subSetting = SubSetting(rawValue: indexPath.row),
//              let targetStoryboard = storyboard?.instantiateViewController(identifier: subSetting.identifier)
//        else { return }

        guard let subSetting = SubSetting(rawValue: indexPath.row)
        else { return }

        performSegue(withIdentifier: subSetting.segueID, sender: self)
//        navigationController?.pushViewController(targetStoryboard, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func logoutButtonPressed() {
        do {
          try Auth.auth().signOut()
        } catch let err {
          print(err)
        }
      }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
