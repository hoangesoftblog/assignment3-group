//
//  HomeViewController.swift
//  AwesomePhoto
//
//  Created by Chau Phuoc Tuong on 4/4/19.
//  Copyright © 2019 Chau Phuoc Tuong. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var controller = UIImagePickerController()
    var videoFileName = "/video.mp4"
    var locationManager = CLLocationManager()
    var locationDictionary = [AnyHashable : Any]()
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("sign out success")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
   
    
    @IBAction func videoTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            // 2 Present UIImagePickerController to take video
            controller.sourceType = .camera
            controller.mediaTypes = [kUTTypeMovie as String]
            controller.delegate = self
            
            present(controller, animated: true, completion: nil)
            locationManager.startUpdatingLocation()
        }
        else {
            print("Camera is not available")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Format the current date time to match the format of
        // the photo's metadata timestamp string
        
        // Format the current date time to match the format of
        // the photo's metadata timestamp string
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY:MM:dd HH:mm:ss"
        let stringFromDate = formatter.string(from: Date())
        
        // Add the location as a value in the location NSMutableDictionary
        // while using the formatted current datetime as its key
        locationDictionary[stringFromDate] = locations

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
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

extension HomeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        locationManager.stopUpdatingLocation()
        
        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            
            // Get the timestamp from the metadata and store it as an NSString
            let selectedPhotoDateTime = ((info[.mediaMetadata] as? [AnyHashable : Any])?["{Exif}"] as? [AnyHashable : Any])?["DateTimeOriginal"]
            
            // If the CLLocationManager is in fact authorized
            // and locations have been found...
            if locationDictionary.keys.count > 0 {
                
                // Sort the location dictionary timestamps in ascending order
                var sortedKeys = locationDictionary.keys.sorted{ $0.hashValue > $1.hashValue }
                
                // As a default, set the selected photo's CLLocation class
                // variable to contain the first value in the sorted dictionary
                let selectedPhotoLocation = locationDictionary[sortedKeys[0]]
                
                // Then go through the location dictionary and set the
                // photo location to whatever value in the dictionary
                //
                
            }
            
            // Save video to the main photo album
            let selectorToCall = #selector(videoSaved(_:didFinishSavingWithError:context:))
            
            // 2
            UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.relativePath, self, selectorToCall, nil)
            // Save the video to the app directory
            let videoData = try? Data(contentsOf: selectedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent(videoFileName)
            try! videoData?.write(to: dataPath, options: [])
        }
        // 3
        picker.dismiss(animated: true)
    }
    
       @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("error saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
            })
        }
    }
}
