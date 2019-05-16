//
//  PhotoActionController.swift
//  assignment3-group
//
//  Created by vang huynh minh tri on 5/13/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Photos
import MobileCoreServices
import AVKit
import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit



class PhotoActionController : UIViewController {
   
    @IBOutlet weak var videoLarge: VideoPlayer!
    @IBOutlet weak var imageLarge: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    var image : UIImage?
    var videoUrl : URL?
    var nameTime : Any?
//    var tabBarController: UITabBarController?
    var txtPosition : CGFloat?
    var imageWatermarked: UIImage?
    var thumbWatermarked: UIImage?
    var thumb: UIImage?
    var videoURLWatermarked: URL?
    var textSize: CGFloat?
    @IBOutlet weak var privateText: UILabel!
    @IBOutlet weak var publicText: UILabel!
    @IBOutlet weak var localSaveSwitch: UISwitch!
    @IBOutlet weak var privacySwitch: UISwitch!
    //    @IBOutlet weak var publicText: UILabel!
//    @IBOutlet weak var privateText: UILabel!
//    @IBOutlet weak var privacySwitch: UISwitch!
    

    @IBAction func checkSwitch(_ sender: Any) {
        if privacySwitch.isOn {
            print("UISwitch is ON")
            privateText.isHidden = true
            publicText.isHidden = false
        } else {
            print("UISwitch is OFF")
            privateText.isHidden = false
            publicText.isHidden = true
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(image)
        print("got here")
        imageView.image = image
        videoLarge.isHidden = true
        imageLarge.image = image
        privateText.isHidden = true
        print(videoUrl)
        let curTime = Date()
        nameTime = ("\(curTime)")
        if(image != nil){
            textSize = 150
            txtPosition = 200
            setFBShare()
//            uploadPhoto()
//            saveImageToLocal()
            imageWatermarked = imageTextWatermark(imageTemp: image!)
            imageLarge.image = imageWatermarked
 //           uploadWatermarkedPhoto()
            
            let content = FBSDKShareLinkContent()
            content.contentURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/assignment3-group.appspot.com/o/Optional(%222019-05-14%2012%3A09%3A47%20%2B0000%22)watermark.mp4?alt=media&token=005446d3-e09c-45aa-9e88-71b9e2e9e02e")
            let newCenter = CGPoint(x: 300, y: 400)
            let shareButton = FBSDKShareButton()
            shareButton.shareContent = content
            print(self.view.center)
            shareButton.center = newCenter
            self.view.addSubview(shareButton)
            
            
            
        }
        if(videoUrl != nil){
            textSize = 20
            txtPosition = 37
//            saveVideoToLocal()
            videoWatermark()
            getImageVideo()
//            uploadThumb()
//            uploadThumbWatermark()
//            uploadVideo()
//            uploadVideoWatermark()
        }
    }
    
    func setFBShare(){
       
        
    }
    
    func saveImageToLocal() {
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func playButtonWatermark(imageTemp: UIImage) -> UIImage {
        let item = MediaItem(image: imageTemp)
        //        imgData = UIImage.pngData(UIImage(named: "Camera-photo.svg")!)()
        let logoImage = UIImage(named: "play-watermark")
        //        print("width:\(logoImage!.size.width)")
        //        print("height:\(logoImage!.size.height)")
        let widthx = item.size.width / 5
        let heighx = item.size.width / 5
        let firstElement = MediaElement(image: logoImage!)
        firstElement.frame = CGRect(x: item.size.width/2 - 50, y: item.size.height/2 - 50, width: widthx, height: heighx)
        
        let testStr = ""
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(textSize!)) ]
        let attrStr = NSAttributedString(string: testStr, attributes: attributes)
        let width2 =    450 + testStr.characters.count*50
        print(testStr.characters.count)
        print(width2)
        print(CGFloat(width2))
        let secondElement = MediaElement(text: attrStr)
        secondElement.frame = CGRect(x: 10, y: item.size.height - txtPosition!, width: 450 + CGFloat(width2), height: 150)
        
        item.add(elements: [firstElement, secondElement])
        var resultImage : UIImage?
        let mediaProcessor = MediaProcessor()
        mediaProcessor.processElements(item: item) { [weak self] (result, error) in
            self!.imageLarge.image = result.image
            resultImage = result.image
            //            self!.saveImageToLocal()
        }
        return resultImage!
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
    func saveVideoToLocal(){
        UISaveVideoAtPathToSavedPhotosAlbum(videoUrl!.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        print("here")
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func imageTextWatermark(imageTemp: UIImage) -> UIImage {
        let item = MediaItem(image: imageTemp)
        //        imgData = UIImage.pngData(UIImage(named: "Camera-photo.svg")!)()
        let logoImage = UIImage(named: "awesome")
//        print("width:\(logoImage!.size.width)")
//        print("height:\(logoImage!.size.height)")
        let widthx = item.size.width / 5
        let heighx = (widthx / logoImage!.size.width) * logoImage!.size.height
        let firstElement = MediaElement(image: logoImage!)
        firstElement.frame = CGRect(x: 10, y: 0, width: widthx, height: heighx)
        let curUser = currentUser!
        let testStr = "\(curUser)"
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(textSize!)) ]
        let attrStr = NSAttributedString(string: testStr, attributes: attributes)
        let width2 =    450 + testStr.characters.count*50
        print(testStr.characters.count)
        print(width2)
        print(CGFloat(width2))
        let secondElement = MediaElement(text: attrStr)
        secondElement.frame = CGRect(x: 10, y: item.size.height - txtPosition!, width: 450 + CGFloat(width2), height: 150)
        
        item.add(elements: [firstElement, secondElement])
        var resultImage : UIImage?
        let mediaProcessor = MediaProcessor()
        mediaProcessor.processElements(item: item) { [weak self] (result, error) in
            self!.imageLarge.image = result.image
            resultImage = result.image
//            self!.saveImageToLocal()
        }
        return resultImage!
    }
    
//    
//    func downloadPhoto(){
//        storageRef.child(self.imageNames[i]).getData(maxSize: INT64_MAX){ data, error in
//            print(self.imageNames[i], separator: "", terminator: " ")
//            if error != nil {
//                print("Error occurs")
//            }
//            else if data != nil {
//                if let imageTemp = UIImage(data: data!) {
//                    print("image available")
//                    self.arrImages[i] = imageTemp
//                }
//            }
//            
//            self.collectionView.reloadData()
//        }
//    }
    
    func videoWatermark(){
        let item2 = MediaItem(url: videoUrl!)
        let logoImage = UIImage(named: "awesome")
        
        let firstElement = MediaElement(image: logoImage!)
        firstElement.frame = CGRect(x: 10, y: item2!.size.height-20, width: logoImage!.size.width/2, height: logoImage!.size.height/2)
        
        let testStr = "\(currentUser!)"
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20) ]
        let attrStr = NSAttributedString(string: testStr, attributes: attributes)
        print("height and width")
        print(item2!.size.height)
        print(item2!.size.width)
        print(testStr.characters.count)
        let secondElement = MediaElement(text: attrStr)
        secondElement.frame = CGRect(x: 20, y: -20, width: 500, height: 50)
        
        item2!.add(elements: [firstElement, secondElement])
        print("checking control")
        let mediaProcessor = MediaProcessor()
        mediaProcessor.processVideoWithElements(item: item2!) { [weak self] (result, error) in
            print(result)
            print("wawawawawa")
            self!.videoURLWatermarked = result.processedUrl
            self!.uploadVideoWatermark()
//            self!.playVideo(url1: result.processedUrl!)
        }
    }
    
    func getImageVideo(){
        let asset = AVURLAsset(url: videoUrl!)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            // !! check the error before proceeding
            var uiImage = UIImage(cgImage: cgImage)
            //            let imageViewX = UIImageView(image: uiImage)
            imageView.image = uiImage
            let item2 = MediaItem(url: videoUrl!)
            if(item2!.size.height > item2!.size.width){
                uiImage = uiImage.rotate(radians: CGFloat(M_PI_2))
            }
            thumb = playButtonWatermark(imageTemp: uiImage)
            
            
            thumbWatermarked = imageTextWatermark(imageTemp: thumb!)
            print("done")
            //            uploadThumbnail(image: uiImage, name: name2)
        }
        catch {
            print("error")
        }
    }
    
    func uploadThumbnail(imageThumb: UIImage){
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        let fileref = Storage.storage().reference().child("/\(nameTime)thumbnail")
        //                imageView.transform =  imageView.transform.rotated(by: CGFloat(M_PI_2))
        //    let image = imageView.image!
        
        //get the PNG data for this image
        //        let data = image.pngData()
        //        let imageToUpload: UIImage = UIImage(cgImage: (self.imageView .image?.cgImage!)!, scale: self.imageView.image!.scale, orientation: .right)
        
        //    let imageData: Data = imageThumb.pngData()!
        let imageData2 = imageThumb.jpegData(compressionQuality: 0.0)
        fileref.putData(imageData2!, metadata: meta, completion: { (meta, error) in
            if error == nil {
                ref.child("userPicture/\(currentUser!)/")
            }
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //All function related to VIDEOS
    func uploadVideo(){
        
        let meta = StorageMetadata()
        meta.contentType = "video"
        //Get user's to create or access user's folder to store images
        //                let userID = Auth.auth().currentUser!.uid
        let fileref2 = Storage.storage().reference().child("\(nameTime).mp4")
        fileref2.putFile(from: videoUrl!, metadata: meta, completion: { (meta, error) in
            if error == nil {
                print("uploaded video to storage")
                
            } else {
                print(error)
            }
        })
        //        self.playVideo(url1: url1)
    }
    func uploadVideoWatermark(){
        
        let meta = StorageMetadata()
        meta.contentType = "video"
        //Get user's to create or access user's folder to store images
        //                let userID = Auth.auth().currentUser!.uid
        let fileref2 = Storage.storage().reference().child("\(nameTime)watermark.mp4")
        fileref2.putFile(from: videoURLWatermarked!, metadata: meta, completion: { (meta, error) in
            if error == nil {
                
                //                self.ref2?.child("userPicture/\(currentUser!)/fileOwned").setValue("\(curTime)")
                print("uploaded video to storage")
                
            } else {
                print(error)
            }
        })
        //        self.playVideo(url1: url1)
    }
    
    func uploadThumb(){
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        
        let fileref = Storage.storage().reference().child("/\(nameTime)thumbnail")
        
        let imageData = thumb!.jpegData(compressionQuality: 0.0)
        fileref.putData(imageData!, metadata: meta, completion: { (meta, error) in
            if error == nil {
                //                ref.child("userPicture/\(currentUser!)/fileOwned").childByAutoId().setValue("\(self.nameTime)thumbnail")
                //
                //                ref.child("fileName/\(self.nameTime)thumbnail/owner").setValue(currentUser!)
                
            }
        })
    }
    func uploadThumbWatermark(){
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        
        let fileref = Storage.storage().reference().child("/\(nameTime)thumbnailwatermark")
        
        let imageData = thumbWatermarked!.jpegData(compressionQuality: 0.0)
        fileref.putData(imageData!, metadata: meta, completion: { (meta, error) in
            if error == nil {
                //                ref.child("userPicture/\(currentUser!)/fileOwned").childByAutoId().setValue("\(self.nameTime)thumbnailwatermark")
                //
                //                ref.child("userPicture/\(currentUser!)/Public").childByAutoId().setValue("\(self.nameTime)thumbnailwatermark")
                //
                //                ref.child("fileName/\(self.nameTime)thumbnailwatermark/owner").setValue(currentUser!)
                //
                //                ref.child("PublicPicture").childByAutoId().setValue("\(self.nameTime)thumbnailwatermark")
            }
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //All function related to PHOTOS
    func uploadPhoto(){
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        
        let fileref = Storage.storage().reference().child("/\(nameTime)")
        
        let imageData = image!.jpegData(compressionQuality: 0.0)
        fileref.putData(imageData!, metadata: meta, completion: { (meta, error) in
            if error == nil {
                //                ref.child("userPicture/\(currentUser!)/fileOwned").childByAutoId().setValue("\(self.nameTime)")
                //
                //                ref.child("fileName/\(self.nameTime)/owner").setValue(currentUser!)
            }
        })
    }
    
    func uploadWatermarkedPhoto(){
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        
        let fileref = Storage.storage().reference().child("/\(nameTime)watermark")
        
        let imageData = imageWatermarked!.jpegData(compressionQuality: 0.0)
        fileref.putData(imageData!, metadata: meta, completion: { (meta, error) in
            if error == nil {
//
//                ref.child("userPicture/\(currentUser!)/Public").childByAutoId().setValue("\(self.nameTime)watermark")
//
//                ref.child("fileName/\(self.nameTime)watermark/owner").setValue(currentUser!)
//
//                ref.child("PublicPicture").childByAutoId().setValue("\(self.nameTime)watermark")
            }
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func proceedToUpload(_ sender: Any) {
        //Privacy on means PUBLIC
        if privacySwitch.isOn {
            //Add node about the file with watermark
            
            if videoUrl != nil {
                ref.child("userPicture/\(currentUser!)/Public").childByAutoId().setValue("\(self.nameTime)thumbnailwatermark")
                ref.child("fileName/\(self.nameTime)thumbnailwatermark/owner").setValue(currentUser!)
                ref.child("publicPicture").childByAutoId().setValue("\(self.nameTime)thumbnailwatermark")
            }
            else if image != nil {
                ref.child("userPicture/\(currentUser!)/Public").childByAutoId().setValue("\(self.nameTime)watermark")
                ref.child("fileName/\(self.nameTime)watermark/owner").setValue(currentUser!)
                ref.child("publicPicture").childByAutoId().setValue("\(self.nameTime)watermark")
            }
        }
        
        if videoUrl != nil {
            uploadVideo()
            uploadThumb()
            uploadThumbWatermark()
            uploadVideoWatermark()
            
            //Add node about file without watermark
            ref.child("userPicture/\(currentUser!)/fileOwned").childByAutoId().setValue("\(self.nameTime)thumbnail")
            ref.child("fileName/\(self.nameTime)thumbnail/owner").setValue(currentUser!)
        }
        else if image != nil {
            uploadPhoto()
            uploadWatermarkedPhoto()
           
            //Add node about the file without watermark
            ref.child("userPicture/\(currentUser!)/fileOwned").childByAutoId().setValue("\(self.nameTime)")
            ref.child("fileName/\(self.nameTime)/owner").setValue(currentUser!)
        }
        
        if localSaveSwitch.isOn {
            if videoUrl == nil {
                saveImageToLocal()
            }
            else if image == nil {
                saveVideoToLocal()
            }
        }
//        let title = "Success"
//        let message = "Video was proceeded successfully"
//
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
         tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: false)


//        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
}
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}
