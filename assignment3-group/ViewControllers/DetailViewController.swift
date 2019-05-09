//
//  DetailViewController.swift
//  assignment3-group
//
//  Created by Hoang, Truong Quoc on 5/1/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit
import Firebase
import AVKit

class SimpleAlert{
    init(warning: String){
        
    }
}

class DetailViewController: UIViewController {
    
    var fileName: String?
    var insetLeft: CGFloat = 20
    var insetTop: CGFloat = 20
    var image: UIImage?
    var videoName: String?
    var database: DatabaseReference?
    
    let selectPerson = "DetailToSelectPerson"
    
    @IBOutlet weak var mainPic: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var videoPlayer: VideoPlayer!
    
    override func viewDidLoad() {
        database = Database.database().reference()
        super.viewDidLoad()
        if fileName!.contains("thumbnail") {
            mainPic.isHidden = true
            videoName = fileName!.replacingOccurrences(of: "thumbnail", with: "")
            videoName += ".mp4"
            print("Value of temp is \(videoName)")
            storageRef.child(videoName).downloadURL {url, error in
                if error != nil {
                    print("Get video url fail")
                    print(error?.localizedDescription)
                }
                
                else if url != nil{
                    print("Get URL good")
                    print(url)
                    let avPlayer = AVPlayer(url: url!)
                    self.videoPlayer.playerLayer.player = avPlayer
                    self.videoPlayer.playerLayer.player?.play()
                }
                
                else {
                    print("No error, but no URL too")
                }
            }
            
        }
        else {
            videoPlayer.isHidden = true
            mainPic.image = image
            
        }
        
        var isFound = false
        database?.child("fileName/\(Media.removeFileExtension(file: fileName!))/owner").observeSingleEvent(of: .value){ snapshot in
            if let val = snapshot.value as? [String: Any]{
                for i in snapshot.childSnapshot(forPath: "additional").children {
                    if let temp = (i as? DataSnapshot) as? String {
                        print("Temp user is \(temp)")
                        if temp == currentUser! {
                            print("Temp user is \(temp), current user is \(currentUser!)")
                            self.usernameButton.setTitle(temp, for: .normal)
                            isFound = true
                        }
                    }
                }
                
                if !isFound {
                    (val["original"] as? String) ?? "No true owner"
                    self.usernameButton.setTitle((val["original"] as? String) ?? "No true owner", for: .normal)
                }
            }
        }
        
    }
    
    @IBAction func pictureAction(_ sender: Any) {
        let action = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        if currentUser == self.usernameButton.currentTitle{
            action.addAction(UIAlertAction(title: "Shared with someone", style: .default) { (_) in
                
                self.performSegue(withIdentifier: self.selectPerson, sender: (self.usernameButton.currentTitle, self.fileName!))
                
            })
        }
        else {
            action.addAction(UIAlertAction(title: "Not the owner so no sharing", style: .default
                , handler: nil))
        }
        
        action.addAction(UIAlertAction(title: "Download with watermark", style: .default) { (_) in
            
            
        })
        
        let temp = UIAlertAction(title: "Download without watermark", style: .default){ _ in
            let location = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0].appendingPathComponent(self.fileName!)
            if (self.fileName?.contains("thumbnail"))! {
                storageRef.child(self.videoName!).write(toFile: location) { url, error in
                    print("URL to download is \(url?.path)")
                    
                    if error != nil {
                        print("Error occurr \(error?.localizedDescription)")
                    }
                    else {
                        print("URL download good")
                    }
                }
            }
            
            else {
                do {
                    try self.image?.pngData()?.write(to: location)
                }
                catch {
                    print("Save image not available")
                }
                
            }
        }
        
        if currentUser != usernameButton.currentTitle {
            temp.isEnabled = false
        }
        
        action.addAction(temp)
        
        action.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { (_) in
            print("Return to normal")
        })
        
        present(action, animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == selectPerson {
            if let temp = segue.destination as? SelectPersonViewController {
                if let (owner, fileName) = sender as? (String, String){
                    temp.owner = owner
                    temp.fileName = fileName
                }
            }
        }
    }
    
    let backToLogin = "backToLogin"
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
