//
//  MainUploadedViewController.swift
//  AwesomePhoto
//
//  Created by Chau Phuoc Tuong on 4/21/19.
//  Copyright © 2019 Chau Phuoc Tuong. All rights reserved.
//

import UIKit
import Firebase
import Photos
import MobileCoreServices
import AVKit
//Upload images, video to firebase and store in model
class MainUploadedViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
//    var imagestore
    override func viewDidLoad() {
        ref2 = Database.database().reference()
        super.viewDidLoad()
        self.display2()
        
        // Do any additional setup after loading the view.
    }
    var choice = 0
    var ref2: DatabaseReference?
    
    @IBOutlet weak var imageView: UIImageView!
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
//            print("Here: \(String(describing: imageView))")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if(choice == 1){
            print("here")
            imagePicker.dismiss(animated: true, completion: nil)
            imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//            imagestore = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            uploadPhoto()
        }
        if(choice == 2){
            print("wawawa")
            dismiss(animated: true, completion: nil)
            guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
                mediaType == (kUTTypeMovie as String),
                let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
                UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
                else { return }
            uploadVideo(url1: url )
            // Handle a movie capture
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    func uploadVideo(url1: URL){
        let meta = StorageMetadata()
        meta.contentType = "video"
        //Get user's to create or access user's folder to store images
        //                let userID = Auth.auth().currentUser!.uid
        var curTime = Date()
//        var namevideo = String(curTime) + ".mp4"
//        let fileref = Storage.storage().reference().child("/\(curTime)")
        //        let image = imageView.image!
        //get the PNG data for this image
        //        let data = image.pngData()
        //        let videoData = try Data(contentsOf: url   as URL)
//        do {
//            let videoData = try Data(contentsOf: url1    as URL)
//            fileref.putData(videoData, metadata: meta, completion: { (meta, error) in
//                if error == nil {
//                    self.ref2?.child("Usershaha/account2/image/test2").setValue("filename")
//                    print("updated")
//
//                }
//            })
//        } catch {
//            print("unable to convert url to data")
//        }
                let fileref2 = Storage.storage().reference().child("\(curTime).mp4")
        fileref2.putFile(from: url1, metadata: meta, completion: { (meta, error) in
            if error == nil {
//                self.ref2?.child("userPicture/\(currentUser!)/fileOwned").setValue("\(curTime)")
                print("uploaded video to storage")
                self.getImageVideo(url1: url1, name: "\(curTime)")
                self.downloadVideo(address: "\(curTime)")
            } else {
                print(error)
            }
        })
//        self.playVideo(url1: url1)
    }
    
    func playVideo(url1: URL){
            var player = AVPlayer(url: url1)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            player.play()
        }
//        getImageVideo(url1: url1,name: "haha")
        
    }
    func downloadVideo(address: String){
//        storageRef.child(address).getData(maxSize: INT64_MAX){ data, error in
//            if error != nil {
//                print("Error occurs. \(error?.localizedDescription)")
//            }
//            else if data != nil {
//                playVideo(url1: data)
//            }
//        }
        storageRef.child("\(address). ").downloadURL { (urlx, error) in
            if urlx == nil {
                print("Error occurs. \(error?.localizedDescription)")
            }
            else if urlx != nil {
                print("link url: \(urlx)")
                self.playVideo(url1: urlx!)
            }
        }
    }
    
    func getImageVideo(url1: URL, name: String){
        var err: NSError? = nil
        var name2 = name + "thumbnail"
        let asset = AVURLAsset(url: url1)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
         do {
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        // !! check the error before proceeding
            let uiImage = UIImage(cgImage: cgImage)
//            let imageViewX = UIImageView(image: uiImage)
            imageView.image = uiImage
            print("done")
            uploadThumbnail(image: uiImage, name: name2)
        }
         catch {
            print("error")
        }
    }
    
    func uploadThumbnail(image: UIImage, name: String){
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        //Get user's to create or access user's folder to store images
        //                let userID = Auth.auth().currentUser!.uid
        let fileref = Storage.storage().reference().child("/\(name)")
        //                imageView.transform =  imageView.transform.rotated(by: CGFloat(M_PI_2))
        let image = imageView.image!
        
        //get the PNG data for this image
        //        let data = image.pngData()
        //        let imageToUpload: UIImage = UIImage(cgImage: (self.imageView .image?.cgImage!)!, scale: self.imageView.image!.scale, orientation: .right)
        
        let imageData: Data = image.pngData()!
        let imageData2 = image.jpegData(compressionQuality: 0.0)
        fileref.putData(imageData2!, metadata: meta, completion: { (meta, error) in
            if error == nil {
                self.ref2?.child("userPicture/\(currentUser!)/fileOwned").childByAutoId().setValue("\(name)")
            }
        })
    }
    func uploadPhoto(){
        var curTime = Date()
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        //Get user's to create or access user's folder to store images
        //                let userID = Auth.auth().currentUser!.uid
        let fileref = Storage.storage().reference().child("/\(curTime)")
//                imageView.transform =  imageView.transform.rotated(by: CGFloat(M_PI_2))
        let image = imageView.image!
        
        //get the PNG data for this image
        //        let data = image.pngData()
//        let imageToUpload: UIImage = UIImage(cgImage: (self.imageView .image?.cgImage!)!, scale: self.imageView.image!.scale, orientation: .right)

        let imageData: Data = image.pngData()!
        let imageData2 = image.jpegData(compressionQuality: 0.0)
        fileref.putData(imageData2!, metadata: meta, completion: { (meta, error) in
            if error == nil {
                self.ref2?.child("userPicture/\(currentUser!)/fileOwned").childByAutoId().setValue("\(curTime)")
            }
        })
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func saveImage(imageName: String){
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get the image we took with camera
        let image = imageView.image!
        //get the PNG data for this image
        let data = image.pngData()
        print(imagePath)
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        //        let name = randomString(length: 10)
        saveImage(imageName: "test")
    }
    func record() {
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
    }
    func display2(){
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Take a photo", style: .default)
        { _ in
            self.takePhoto()
            print("Take a photo")
            self.choice = 1;
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Record video", style: .default)
        { _ in
            self.choice = 2;
            self.record()
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    func displayActionSheet(){
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Delete", style: .default)
        let saveAction = UIAlertAction(title: "Save", style: .default)
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        print("here")
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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

