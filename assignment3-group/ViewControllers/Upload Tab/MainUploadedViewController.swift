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
import Foundation
//Upload images, video to firebase and store in model
class MainUploadedViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var displayActionsheet: Bool = true
    var imagePicker = UIImagePickerController()
//    var imagestore
    override func viewDidLoad() {
        ref2 = Database.database().reference()
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    func goToSegue(){
        performSegue(withIdentifier: PhotoActionSegue, sender: imageView.image)
    }
    override func viewDidAppear(_ animated: Bool) {
        if displayActionsheet{
            self.display2()
        }
        if choice == 0 {
        print("YOLO!!!!!!!!1")
        }
        else{
            choice = 0
            displayActionsheet = true
            goToSegue()
        }
    }
    let photoEdit = "PhotoEdit"
    var choice = 0
    var ref2: DatabaseReference?
    let PhotoActionSegue = "PhotoActionSegue"
    @IBOutlet weak var imageView2: UIImageView!
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
    func saveImageToLocal() {
        guard let image = imageView2.image else {
            print ("here1")
             return }
        print("here2")
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func saveVideoToLocal(url: URL){
        UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if(choice == 1){
            print("here")
            imagePicker.dismiss(animated: true, completion: nil)
            imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//            imagestore = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//            uploadPhoto()
            print("Tri map")
            displayActionsheet = false
            print("currently is in mainthread\(Thread.isMainThread)")
//            performSegue(withIdentifier: photoEdit, sender: (Any).self)
//            goToSegue()
//            twoImageWatermark()
//            imageTextWatermark()
//            performSegue(withIdentifier: PhotoActionSegue, sender: imageView.image)
        //    performSegue(withIdentifie, sender: <#T##Any?#>)
        }
        if(choice == 2){
            print("wawawa")
            dismiss(animated: true, completion: nil)
            guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
                mediaType == (kUTTypeMovie as String),
                let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
                UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
                else { return }
            saveVideoToLocal(url: url)
            uploadVideo(url1: url )
            // Handle a movie capture
            
        }
        
        
    }
    func uploadVideo(url1: URL){
        
        let meta = StorageMetadata()
        meta.contentType = "video"
        //Get user's to create or access user's folder to store images
        //                let userID = Auth.auth().currentUser!.uid
        var curTime = Date()
                let fileref2 = Storage.storage().reference().child("\(curTime).mp4")
        fileref2.putFile(from: url1, metadata: meta, completion: { (meta, error) in
            if error == nil {
                self.videoWatermark(url: url1)
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
        storageRef.child("\(address).mp4").downloadURL { (urlx, error) in
            if urlx == nil {
                print("Error occurs. \(error?.localizedDescription)")
            }
            else if urlx != nil {
                print("link url: \(urlx)")
//                self.videoWatermark(url: urlx!)
//                self.playVideo(url1: urlx!)
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

        let fileref = Storage.storage().reference().child("/\(curTime)")

        let image = imageView.image!


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
    

    
    func twoImageWatermark(){
        print("running two iamge water mark")
        let item = MediaItem(image: imageView.image!)
        //        imgData = UIImage.pngData(UIImage(named: "Camera-photo.svg")!)()
        let logoImage = UIImage(named: "awesome")
        if(logoImage == nil) {
            print("cannot file image")
        }
        let widthx = item.size.width / 5
        let heighx = (widthx / logoImage!.size.width) * logoImage!.size.height
        let firstElement = MediaElement(image: logoImage!)
        firstElement.frame = CGRect(x: 0, y: 0, width: widthx, height: heighx)

        let secondElement = MediaElement(image: logoImage!)
        secondElement.frame = CGRect(x: 0, y: 300, width: widthx, height: heighx)
        
        item.add(elements: [firstElement, secondElement])
        
        let mediaProcessor = MediaProcessor()
        mediaProcessor.processElements(item: item) { [weak self] (result, error) in
            print("get result image")
            self!.imageView2.image = result.image
            self!.saveImageToLocal()
        }
    }
    
    func videoWatermark(url: URL){
        
            let item2 = MediaItem(url: url)
            let logoImage = UIImage(named: "awesome")
            
            let firstElement = MediaElement(image: logoImage!)
            firstElement.frame = CGRect(x: 0, y: item2!.size.height-20, width: logoImage!.size.width/2, height: logoImage!.size.height/2)
            
            let testStr = "Attributed Textaaaaaaaaaa"
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10) ]
            let attrStr = NSAttributedString(string: testStr, attributes: attributes)
        print("height and width")
        print(item2!.size.height)
        print(item2!.size.width)
        print(testStr.characters.count)
            let secondElement = MediaElement(text: attrStr)
            secondElement.frame = CGRect(x: 0, y: -20, width: 500, height: 50)
            
        item2!.add(elements: [firstElement, secondElement])
            print("checking control")
            let mediaProcessor = MediaProcessor()
        mediaProcessor.processVideoWithElements(item: item2!) { [weak self] (result, error) in
            print(result)
            print("wawawawawa")
            self!.playVideo(url1: result.processedUrl!)
            }
    }
    
    
    func imageTextWatermark(){
        let item = MediaItem(image: imageView.image!)
        //        imgData = UIImage.pngData(UIImage(named: "Camera-photo.svg")!)()
        let logoImage = UIImage(named: "awesome")
        let widthx = item.size.width / 5
        let heighx = (widthx / logoImage!.size.width) * logoImage!.size.height
        let firstElement = MediaElement(image: logoImage!)
        firstElement.frame = CGRect(x: 10, y: 0, width: widthx, height: heighx)
        
        let testStr = "\(String(describing: currentUser!)) Nguyen"
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 150) ]
        let attrStr = NSAttributedString(string: testStr, attributes: attributes)
        let width2 =    450 + testStr.characters.count*50
        print(testStr.characters.count)
        print(width2)
        print(CGFloat(width2))
        let secondElement = MediaElement(text: attrStr)
        secondElement.frame = CGRect(x: 10, y: item.size.height-230, width: 450 + CGFloat(width2), height: 250)
        
        item.add(elements: [firstElement, secondElement])
        
        let mediaProcessor = MediaProcessor()
        mediaProcessor.processElements(item: item) { [weak self] (result, error) in
            self!.imageView2.image = result.image
           self!.saveImageToLocal()
        }
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
//            self.performSegue(withIdentifier: self.photoEdit, sender: (Any).self)
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PhotoActionSegue {
            if let dest = segue.destination as? PhotoActionController {
                if let image = sender as? (UIImage) {
                   dest.image = image
//                    dest.fileName = name
                }
            }
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

