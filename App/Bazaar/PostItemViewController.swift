//
//  PostItemViewController.swift
//  Bazaar
//
//  Created by Marko Stepniczka on 10/23/21.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import Firebase

class PostItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToolbar()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @IBAction func selectPhotoPressed(_ sender: Any) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self // new
        present(imagePickerVC, animated: true)
    }

    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var previewImage: UIImageView!
    var storageRef = Storage.storage().reference()
    var databaseRef = Database.database().reference()
    var downloadURL: String!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            previewImage.image = image
        }
        
        var data = Data()
        data = previewImage.image!.jpegData(compressionQuality: 0.5)!
            // set upload path
        let filePath = "Posts/\(PurchaseListViewController.storeTappedOnList)"
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
        
            self.storageRef.child(filePath).putData(data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    self.databaseRef.child("Users").child(Auth.auth().currentUser!.uid).updateChildValues(["Posts": filePath])
                }
            }
    
    }
    
    func setupToolbar(){
    //Create a toolbar
    let bar = UIToolbar()
    //Create a done button with an action to trigger our function to dismiss the keyboard
    let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
    //Create a felxible space item so that we can add it around in toolbar to position our done button
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    //Add the created button items in the toobar
    bar.items = [flexSpace, flexSpace, doneBtn]
    bar.sizeToFit()
    //Add the toolbar to our textfield
    commentTextView.inputAccessoryView = bar
    }
    
    @objc func dismissMyKeyboard(){
    view.endEditing(true)
    }
    
    @IBAction func postButtonPressed() {
        let ref = Database.database().reference().child("Posts").child("\(PurchaseListViewController.storeTappedOnList)")
        let postDictionary = ["description": ItemInfoViewController.storeItemDescription as Any,
                                "itemName": ItemInfoViewController.storeItemName as Any,
                                "retailer": ItemInfoViewController.storeRetailer as Any,
                                "caption": commentTextView.text as Any,
                                "image": "Posts/\(PurchaseListViewController.storeTappedOnList)",
                                "likes": 0,
                                "points": 24,
                                "itemID": PurchaseListViewController.storeTappedOnList,
                                "userID": Auth.auth().currentUser!.uid] as [String : Any]
        ref.setValue(postDictionary)
    }
}
