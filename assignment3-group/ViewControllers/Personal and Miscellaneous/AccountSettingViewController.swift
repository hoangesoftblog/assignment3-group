//
//  AccountSettingViewController.swift
//  assignment3-group
//
//  Created by Chau Phuoc Tuong on 5/8/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit
import FirebaseAuth
import Photos

class AccountSettingViewController: UIViewController {
    
    
    
    @IBAction func deleteAccount(_ sender: Any) {
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                // An error happened.
            } else {
                // Account deleted.
            }
        }
        let alertDelete = UIAlertController(title: "Alert", message: "Your account has been deleted", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Done", style: .default) {
            (action:UIAlertAction) in print("You pressed the done");
        }
        alertDelete.addAction(action)
        self.present(alertDelete, animated: true, completion: nil)
    }
    
    @IBAction func autoUploadTapped(_ sender: Any) {
        // https://stackoverflow.com/questions/28708846/how-to-save-image-to-custom-album
        class CustomPhotoAlbum {
            
            static let albumName = "My Album"
            static let sharedInstance = CustomPhotoAlbum()
            
            var assetCollection: PHAssetCollection!
            
            init() {
                
                func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
                    
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
                    let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                    
                    if let firstObject: AnyObject = collection.firstObject {
                        return collection.firstObject as! PHAssetCollection
                    }
                    
                    return nil
                }
                
                if let assetCollection = fetchAssetCollectionForAlbum() {
                    self.assetCollection = assetCollection
                    return
                }
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)
                }) { success, _ in
                    if success {
                        self.assetCollection = fetchAssetCollectionForAlbum()
                    }
                }
            }
            
            func saveImage(image: UIImage) {
                
                if assetCollection == nil {
                    return   // If there was an error upstream, skip the save.
                }
                
                PHPhotoLibrary.shared().performChanges({
                    let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
                    let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
                    albumChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)
                }, completionHandler: nil)
            }
            
            
        }

        
    }
    
    
    @IBAction func autoSaveTapped(_ sender: Any) {
        UserDefaults.standard.set("on", forKey: "autosave")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let color = UserDefaults.standard.object(forKey: "bgColor") as? String else {
            return
        }
        if color == "yellow" {
            self.view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        }
        
        let autosave = UserDefaults.standard.set("on", forKey: "autosave") as? String
        if autosave == "on" {
            let alert = UIAlertController(title: "Saved Image", message: "Your image is saved", preferredStyle: UIAlertController.Style.alert)
            let confirmAlert1 = UIAlertAction(title: "Done", style: .default) {(action:UIAlertAction) in print("You chose save");
            }
            alert.addAction(confirmAlert1)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alertDeny = UIAlertController(title: "Deny to save", message: "Your images is unsaved", preferredStyle: UIAlertController.Style.alert)
            let confirmAlert2 = UIAlertAction(title: "Done", style: .default) {(action:UIAlertAction) in print("You chose deny saving");
            }
            alertDeny.addAction(confirmAlert2)
            self.present(alertDeny, animated: true, completion: nil)
            // show alert confirm save k?
            // alertaction: Save
        }
        // Do any additional setup after loading the view.
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
