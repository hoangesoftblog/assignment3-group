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

class DetailViewController: UIViewController {
    
    var fileName: String?
    var insetLeft: CGFloat = 20
    var insetTop: CGFloat = 20
    var image: UIImage?
    var videoName: String?
    var database: DatabaseReference?
    var videoURL: URL?
    let selectPerson = "DetailToSelectPerson"
    let goToPersonalPage = "goToPersonalPage"
    var isShared = false
    
    @IBAction func openPersonalPage(_ sender: Any) {
        performSegue(withIdentifier: goToPersonalPage, sender: usernameButton.currentTitle)
    }
    @IBOutlet weak var mainPic: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var videoPlayer: VideoPlayer!
    
    override func viewDidLoad() {
        database = Database.database().reference()
        super.viewDidLoad()
        
        
        let imagetappedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        mainPic.isUserInteractionEnabled = true
        mainPic.addGestureRecognizer(imagetappedGestureRecognizer)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(videoTapped(tapGestureRecognizer:)))
           videoPlayer.isUserInteractionEnabled = true
           videoPlayer.addGestureRecognizer(tapGestureRecognizer)
        if fileName!.contains("thumbnail") {
            mainPic.isHidden = true
            videoName = fileName!.replacingOccurrences(of: "thumbnail", with: "")
            videoName! += ".mp4"
            
            let thumbnailHeight = (image?.size.height)!, thumbnailWidth = (image?.size.width)!
            print("Size of thumbnail is height: \(thumbnailHeight), width: \(thumbnailWidth)")
            print("Value of temp is \(videoName)")
            videoPlayer.frame = CGRect(x: videoPlayer.frame.origin.x, y: videoPlayer.frame.origin.y, width: videoPlayer.frame.width, height: videoPlayer.frame.width * thumbnailHeight / thumbnailWidth)
            print("Size of view is x: \(videoPlayer.frame.origin.x), y: \(videoPlayer.frame.origin.y), width: \(videoPlayer.frame.width), height: \(videoPlayer.frame.height)")
            
            storageRef.child(videoName!).downloadURL {url, error in
                if error != nil {
                    print("Get video url fail")
                    print(error?.localizedDescription)
                }
                
                else if url != nil{
                    print("Get URL good")
                    print(url)
                    let avPlayer = AVPlayer(url: url!)
                    self.videoURL = url
                    let castedLayer = self.videoPlayer.layer as! AVPlayerLayer
                    self.videoPlayer.playerLayer.player = avPlayer
                    self.videoPlayer.playerLayer.player?.play()
                    
//                    _ = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.playVideo))
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
        database?.child("fileName/\(Media.removeFileExtension(file: fileName!))").observeSingleEvent(of: .value){ snapshot in
            if let val = snapshot.value as? [String: Any]{
                for i in snapshot.childSnapshot(forPath: "SharedWithoutWatermark").children {
                    if let temp = (i as? DataSnapshot)?.value as? String {
                        print("Temp user is \(temp)")
                        if temp == currentUser! {
                            print("Temp user is \(temp), current user is \(currentUser!)")
                            self.usernameButton.setTitle(temp, for: .normal)
                            isFound = true
                        }
                    }
                }
                
                if !isFound {
                    self.usernameButton.setTitle((val["owner"] as? String) ?? "No true owner", for: .normal)
                    for i in snapshot.childSnapshot(forPath: "SharedWithWatermark").children {
                        if let temp = (i as? DataSnapshot)?.value as? String {
                            print("Temp user is \(temp)")
                            if temp == currentUser! {
                                print("Temp user is \(temp), current user is \(currentUser!)")
                                self.isShared = true
                            }
                        }
                    }
                }
            }
        }
        
    }
    
//    @objc func playVideo(){
//        var player = AVPlayer(url: videoURL!)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//
//        present(playerViewController, animated: true) {
//            player.play()
//        }
//    }
    
//    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
//        let imageView = sender.view as! UIImageView
//        let newImageView = UIImageView(image: imageView.image)
//        newImageView.frame = UIScreen.main.bounds
//        newImageView.backgroundColor = .black
//        newImageView.contentMode = .scaleAspectFit
//        newImageView.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissFullscreenImage:"))
//        newImageView.addGestureRecognizer(tap)
//        self.view.addSubview(newImageView)
//        self.navigationController?.isNavigationBarHidden = true
//        self.tabBarController?.tabBar.isHidden = true
//    }
//
//    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
//        self.navigationController?.isNavigationBarHidden = false
//        self.tabBarController?.tabBar.isHidden = false
//        sender.view?.removeFromSuperview()
//    }
//
    @objc func videoTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        var player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
        
                present(playerViewController, animated: true) {
                    player.play()
                }
        
        // Your action
    }
 
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "DisplaySegue", sender: (mainPic.image,fileName))
    }
//        let imageView = tapGestureRecognizer.view as! UIImageView
//        let newImageView = UIImageView(image: imageView.image)
//                newImageView.frame = UIScreen.main.bounds
//                newImageView.backgroundColor = .black
//                newImageView.contentMode = .scaleAspectFit
//                newImageView.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(sender:)))
//                newImageView.addGestureRecognizer(tap)
//                self.view.addSubview(newImageView)
//                self.navigationController?.isNavigationBarHidden = true
//                self.tabBarController?.tabBar.isHidden = true
//            }
//    @objc func dismissFullscreenImage(sender: UITapGestureRecognizer) {
//                self.navigationController?.isNavigationBarHidden = false
//                self.tabBarController?.tabBar.isHidden = false
//        sender.view?.removeFromSuperview()
//            }

    

    @IBAction func pictureAction(_ sender: Any) {
        let action = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        if isShared {
            let removeFromShared = UIAlertAction(title: "Remove from shared tab", style: .default){ (_) in
                ref.child("userPicture/\(currentUser!)/fileSharedWithWatermark").queryEqual(toValue: self.fileName!).ref.setValue(nil)
                
                ref.child("fileName/\(Media.removeFileExtension(file: self.fileName!))/SharedWithWatermark").queryEqual(toValue: currentUser!).ref.setValue(nil)
            }
            removeFromShared.setValue(UIColor.red, forKey: "titleTextColor")
            action.addAction(removeFromShared)
        }
        
        action.addAction(UIAlertAction(title: "Copy file link to clipboard", style: .default) { (_) in
            var workingFileName = (self.videoName == nil) ? self.fileName! : self.videoName!
            
            storageRef.child("\(workingFileName)").downloadURL { (urlx, error) in
                if urlx == nil {
                    print("Error occurs. \(error?.localizedDescription)")
                }
                else if urlx != nil {
                    UIPasteboard.general.string = (urlx?.absoluteString)
                    
                    let tempAlert = UIAlertController(title: "Link copied", message: "Link is stored in your clipboard", preferredStyle: .alert)
                    tempAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(tempAlert, animated: true, completion: nil)
                }
            }
        })
        
        if currentUser == self.usernameButton.currentTitle{
            action.addAction(UIAlertAction(title: "Shared with someone", style: .default) { (_) in
                
                self.performSegue(withIdentifier: self.selectPerson, sender: (self.usernameButton.currentTitle, self.fileName!))
                
            })
        }
        else {
            action.addAction(UIAlertAction(title: "Not the owner so no sharing", style: .default
                , handler: nil))
        }
        
        let downWithWatermark = UIAlertAction(title: "Download with watermark", style: .default) { (_) in
//            let location = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0].appendingPathComponent(self.fileName!)
//            if (self.fileName?.contains("thumbnail"))! {
//                let downloadTask = storageRef.child(self.videoName!).write(toFile: location) { url, error in
//                    print("URL to download is \(url?.path)")
//
//                    if error != nil {
//                        print("Error occurr \(error?.localizedDescription)")
//                    }
//                    else {
//                        print("URL download good")
//                    }
//                }
//
//                downloadTask.observe(.success) { snapshot in
//                    let tempAction = UIAlertController(title: "Download finished", message: "Video downloaded successfully, file is saved in Download folder", preferredStyle: .alert)
//                    tempAction.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                    self.present(tempAction, animated: true, completion: nil)
//                }
//
//                downloadTask.observe(.failure) { snapshot in
//                    let tempAction = UIAlertController(title: "Download failed", message: "Video downloaded failed, please download again", preferredStyle: .alert)
//                    tempAction.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                    self.present(tempAction, animated: true, completion: nil)
//                }
//            }
//
//            else {
//                do {
//                    try self.image?.pngData()?.write(to: location)
//                    let tempAction = UIAlertController(title: "Download finished", message: "Image downloaded successfully, file is saved in Download folder", preferredStyle: .alert)
//                    tempAction.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                }
//                catch {
//                    let tempAction = UIAlertController(title: "Download failed", message: "Image downloaded failed, please download again", preferredStyle: .alert)
//                    tempAction.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                }
//
//            }
            let tempAction = UIAlertController(title: "Not available", message: "Not configured yet", preferredStyle: .alert)
            tempAction.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(tempAction, animated: true, completion: nil)
        }
        action.addAction(downWithWatermark)
        
        let temp = UIAlertAction(title: "Download without watermark", style: .default){ _ in
            let location = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0].appendingPathComponent(self.fileName!)
            if (self.fileName?.contains("thumbnail"))! {
                let downloadTask = storageRef.child(self.videoName!).write(toFile: location) { url, error in
                    print("URL to download is \(url?.path)")
                    
                    if error != nil {
                        print("Error occurr \(error?.localizedDescription)")
                    }
                    else {
                        print("URL download good")
                    }
                }
                
                downloadTask.observe(.success) { snapshot in
                    let tempAction = UIAlertController(title: "Download finished", message: "Video downloaded successfully, file is saved in Download folder", preferredStyle: .alert)
                    tempAction.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(tempAction, animated: true, completion: nil)
                }
                
                downloadTask.observe(.failure) { snapshot in
                    let tempAction = UIAlertController(title: "Download failed", message: "Video downloaded failed, please download again", preferredStyle: .alert)
                    tempAction.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(tempAction, animated: true, completion: nil)
                }
            }
            
            else {
                do {
                    try self.image?.pngData()?.write(to: location)
                    let tempAction = UIAlertController(title: "Download finished", message: "Image downloaded successfully, file is saved in Download folder", preferredStyle: .alert)
                    tempAction.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(tempAction, animated: true, completion: nil)
                }
                catch {
                    let tempAction = UIAlertController(title: "Download failed", message: "Image downloaded failed, please download again", preferredStyle: .alert)
                    tempAction.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(tempAction, animated: true, completion: nil)
                }
                
            }
        }
        
        if currentUser != usernameButton.currentTitle {
            temp.isEnabled = false
        }
        
        action.addAction(temp)
        
        if usernameButton.currentTitle != currentUser {
            action.addAction(UIAlertAction(title: "Buy this photo", style: .default){ (_) in
                
            })
        }
        
        
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (_) in
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
        else if segue.identifier == goToPersonalPage {
            if let temp = segue.destination as? MainPersonalViewController {
                if let accessingUser = sender as? String{
                    temp.showingUser = accessingUser
                    temp.isLeftBarAbleToShow = false
                }
            }
        }else if segue.identifier == "DisplaySegue" {
            if let temp = segue.destination as? DisplayViewController {
                if let (image,fileName) = sender as? (UIImage?,String?) {
                    temp.image = image
                    temp.fileName = fileName
                }
            }
        }
    }
    
}

