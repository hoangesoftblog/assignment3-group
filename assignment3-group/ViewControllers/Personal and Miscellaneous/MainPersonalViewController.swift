//
//  MainPersonalController.swift
//  SideMenu
//
//  Created by namtranx on 4/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Firebase
import Photos

private let reuseIdentifier = "personalCollectionViewCell"

class MainPersonalViewController: UIViewController{
    var showingUser: String?
    let sectionInsets = UIEdgeInsets(top: 50.0,
                                     left: 20.0,
                                     bottom: 50.0,
                                     right: 20.0)
    var numberOfColumns: CGFloat = 2
    let goToAccountSetting = "goToAccountSetting"
    let goToAppearance = "goToAppearance"
    let goToStatistic = "goToStatistic"
    
    //@IBOutlet weak var usernameLabel: UILabel!
    
//    @IBOutlet weak var jobLabel: UILabel!
    
//    @IBOutlet weak var topView: UIView!
    
//    @IBOutlet weak var avtImageView: UIImageView!
    
//    @IBOutlet weak var uploadPhotoImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var sideViewLeadingContraint: NSLayoutConstraint!
    
//    @IBOutlet weak var choiceOfColumns: UISegmentedControl!
//    @IBAction func switchView(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            numberOfColumns = 1
//        case 1:
//            numberOfColumns = 2
//        default:
//            break
//        }
//        
//        self.collectionView.reloadData()
//    }
//    
//    var menuShowing: Bool = false
//    var imageNames = [String]()
//    var arrImages = [Int: UIImage]()
//    
//    @IBOutlet weak var sideView: UIView!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if showingUser != nil {
//            sideView.isHidden = true
//        }
//        
//        sideView.layer.borderWidth = 0.25
//        sideView.layer.borderColor = UIColor.lightGray.cgColor
//        
////        usernameLabel.text = currentUser
////        updateUI()
////        collectionView.delegate = self
////        collectionView.dataSource = self
//        grabPhoto()
////        numberOfColumns = CGFloat( choiceOfColumns.selectedSegmentIndex + 1)
////        if let layout = collectionView?.collectionViewLayout as? CollectionViewPhotoLayout {
////            layout.delegate = self as? LayoutDelegate
////
////        }
//    
//    }
//    
//    func grabPhoto(){
////        let iM = PHImageManager.default()
////        let iMRequest = PHImageRequestOptions()
////        iMRequest.isSynchronous = true
////        iMRequest.deliveryMode = .highQualityFormat
////
////        let fetchOptions = PHFetchOptions()
////
////        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
////
////        if let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
////            if fetchResult.count > 0  {
////                for i in 0..<fetchResult.count {
////                    iM.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: iMRequest, resultHandler: {
////                        image , error in
////
////                        self.arrImages.append(image!)
////                    })
////                }
////            }
////            else {
////                print("You dont have photo")
////                self.collectionView.reloadData()
////            }
////        }
//        var workingUser: String = (showingUser == nil) ? currentUser! : showingUser!
//        
//        ref.child("userPicture/\(workingUser)/fileOwned").observeSingleEvent(of: .value){ snapshot in
//            for i in snapshot.children {
//                if let i2 = (i as? DataSnapshot)?.value as? String {
//                    self.imageNames.append(i2)
//                }
//            }
//            
//            print("\n\n\n\n\(self.imageNames.count) images found\n\n\n\n")
//            self.collectionView.reloadData()
//            
//            for i in 0..<self.imageNames.count {
//                storageRef.child(self.imageNames[i]).getData(maxSize: INT64_MAX){ data, error in
//                    print(self.imageNames[i], separator: "", terminator: " ")
//                    if error != nil {
//                        print("Error occurs. \(error?.localizedDescription)")
//                    }
//                    else if data != nil {
//                        if let imageTemp = UIImage(data: data!) {
//                            print("image available")
//                            self.arrImages[i] = imageTemp
//                        }
//                    }
//                    
//                    self.collectionView.reloadData()
//                }
//            }
//        }
//    }
//    
////    func getImagesOfUser(){
////        let userID = Auth.auth().currentUser?.uid
////        ref.child("userPicture").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
////            // Get user value
////            let value = snapshot.value as? NSDictionary
////            let username = value?["username"] as? String ?? ""
////            let email = value?["email"] as? String ?? ""
////            let fullName = value?["fullName"] as? String ?? ""
////            let avtImage = value?["avtImage"] as? String ?? ""
////            //let arrImages: Dictionary = value?[""] as? Dictionary
////            //let user = User(id: userID!, email: email, fullName: fullName, avtImage: avtImage, arrImages: arrImages)
////
////            // ...
////        }) { (error) in
////            print(error.localizedDescription)
////        }
////    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//    }
//    
//    func updateUI(){
//        
////        avtImageView.layer.cornerRadius = avtImageView.frame.height / 2.0
////        avtImageView.layer.masksToBounds = true
////        uploadPhotoImageView.layer.cornerRadius = uploadPhotoImageView.frame.height/2
////        uploadPhotoImageView.layer.masksToBounds = true
//        
//    }
//    
//    @IBAction func toggledTapped(_ sender: Any) {
//        if menuShowing{
//            sideViewLeadingContraint.constant = -200
//        }else{
//            sideViewLeadingContraint.constant = 0
//        }
//        
//        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//        
//        menuShowing = !menuShowing
//        
//    }
//    
//    @IBAction func acountSettings(_ sender: UITapGestureRecognizer) {
//        performSegue(withIdentifier: goToAccountSetting, sender: self)
//    }
//    
//    @IBAction func appearanceTapped(_ sender: UITapGestureRecognizer) {
//        performSegue(withIdentifier: goToAppearance, sender: self)
//    }
//    
////    @IBAction func staticTapped(_ sender: UITapGestureRecognizer) {
////        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
////        let aboutVC = storyboard.instantiateViewController(withIdentifier: "StatisticsViewController") as! StatisticsViewController
////        self.show(aboutVC, sender: nil)
////    }
//    
//    @IBAction func logoutTapped(_ sender: UITapGestureRecognizer) {
//        do {
//            try Auth.auth().signOut()
//            self.dismiss(animated: true, completion: nil)
//        }
//        catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//    }
//    
//    @IBAction func aboutTapped(_ sender: UITapGestureRecognizer) {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let aboutVC = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
//        self.show(aboutVC, sender: nil)
//    }
//    
//}
//
//extension MainPersonalViewController: UICollectionViewDataSource{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        print("number of sections")
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("\(arrImages.count) picture found")
//        return arrImages.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print()
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//        if let customCell = cell as? PhotoCollectionViewCell {
//            if indexPath.row < arrImages.count {
//                customCell.imageViewInCell.image = arrImages[indexPath.row]
//                return customCell
//            }
//        }
//        
//        return cell
//    }
//    
//    
//}
//
////extension MainPersonalViewController : LayoutDelegate {
////
////    // 1. Returns the photo height
////    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
////
////        return arrImages[indexPath.item]!.size.height
////    }
////
////}
//
//extension MainPersonalViewController: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let paddingSpace = sectionInsets.left * (numberOfColumns + 1)
//        let available = view.frame.width - paddingSpace
//        let widthPerItem = available / numberOfColumns
//        
//        //print("IndexPath row is \(indexPath.row)")
//        //print("imagePhoto has \(imagePhoto.count)\n")
//        if indexPath.row < arrImages.count && arrImages[indexPath.row] != nil {
//            //print("\(photoHeight)\t\(photoWidth)")
//            
//            return CGSize(width: widthPerItem, height: widthPerItem * ((arrImages[indexPath.row]?.size.height)! / (arrImages[indexPath.row]?.size.width)!))
//        }
//        else {
//            return CGSize(width: widthPerItem, height: widthPerItem)
//        }
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//    
//    // 4
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
//}
//
//extension MainPersonalViewController{
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind{
//        case UICollectionView.elementKindSectionHeader:
//            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PersonalHeaderViewController", for: indexPath) as? PersonalHeaderViewController
//                
//                else{
//                    fatalError("Invalid personal view type")
//            }
//            
//            if showingUser == nil {
//                headerView.usernameLabel.text = currentUser
//            }
//            else {
//                headerView.usernameLabel.text = showingUser
//                headerView.changeBackgroundButton.isHidden = true
//                headerView.uploadPhotoImageView.isHidden = true
//            }
//            
//            headerView.layer.cornerRadius = headerView.avtImageView.frame.height / 2.0
//            headerView.uploadPhotoImageView.layer.masksToBounds = true
//            headerView.uploadPhotoImageView.layer.cornerRadius = headerView.uploadPhotoImageView.frame.height/2
//            headerView.uploadPhotoImageView.layer.masksToBounds = true
//            
//            numberOfColumns = CGFloat(headerView.choiceOfColumns.selectedSegmentIndex + 1)
//            headerView.choiceOfColumns.addTarget(self, action: #selector(switchView(_:)), for: .valueChanged)
//            
//            
//            return headerView
//            
//        default:
//            assert(false, "invalid element type")
//        }
//        
//        
//    }
//    
//    
//    
//    
//    
//    
//    
}


