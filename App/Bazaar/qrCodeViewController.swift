//
//  ProfileViewController.swift
//  Bazaar
//
//  Created by Ankit Mehta on 10/23/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class qrCodeViewController: UIViewController {
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uid = Auth.auth().currentUser?.uid as! String
        
        let data = uid.data(using: String.Encoding.ascii)
        // 3
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        // 4
        qrFilter.setValue(data, forKey: "inputMessage")
        // 5
        guard let qrImage = qrFilter.outputImage else { return }
        
        self.qrCodeImage.image = UIImage(ciImage: qrImage)
    }
    
    
    

}
