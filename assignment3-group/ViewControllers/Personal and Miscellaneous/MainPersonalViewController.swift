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
import FBSDKLoginKit

private let reuseIdentifier = "personalCollectionViewCell"

class MainPersonalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var profilePic: UIImage?
    var isLeftBarAbleToShow = true
    var showingUser: String?
    let fromPersonalToDetail = "fromPersonalToDetail"
    let sectionInsets = UIEdgeInsets(top: 50.0,
                                     left: 20.0,
                                     bottom: 50.0,
                                     right: 20.0)
    var numberOfColumns: CGFloat = 2
    let goToAccountSetting = "goToAccountSetting"
    let goToAppearance = "goToAppearance"
    let goToStatistic = "goToStatistic"
    let refreshControl = UIRefreshControl()
    
//    @IBOutlet weak var usernameLabel: UILabel!
//
//    @IBOutlet weak var jobLabel: UILabel!
//
//    @IBOutlet weak var topView: UIView!
//
//    @IBOutlet weak var avtImageView: UIImageView!
    
   
    
    var choice = 0
    var ref2: DatabaseReference?
    var isNewest = true
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var sideViewLeadingContraint: NSLayoutConstraint!
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            numberOfColumns = 1
        case 1:
            numberOfColumns = 2
        default:
            break
        }
        
        self.collectionView.reloadData()
    }
    
    var menuShowing: Bool = false
    var imageNames = [String]()
    var originalArrImages = [Int: UIImage]()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(removingSetting(sender:)))

    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var usernameLabelSideView: UILabel!
    
//    @IBOutlet weak var removingSettingView: UIView!
    @IBOutlet weak var removingSettingView: UIView!
    
    @objc func refreshView(){
        print("\n\nrefresing view working\n\n")
        originalArrImages.removeAll()
        imageNames.removeAll()
        grabPhoto()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideView.layer.borderWidth = 0.25
        sideView.layer.borderColor = UIColor.lightGray.cgColor
        
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = refreshControl
        } else {
            self.collectionView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading")
        
        updateUI()
//        collectionView.delegate = self
//        collectionView.dataSource = self
        grabPhoto()
//        numberOfColumns = CGFloat( choiceOfColumns.selectedSegmentIndex + 1)
//        if let layout = collectionView?.collectionViewLayout as? CollectionViewPhotoLayout {
//            layout.delegate = self as? LayoutDelegate
//
//        }
        
        getProfileImage()
    }
    
    func getProfileImage(){
        ref.child("userPicture/\((showingUser == nil) ? currentUser! : showingUser!)/avtImage").observeSingleEvent(of: .value){ snapshot in
            if let avt = snapshot.value as? String {
                print("profile picture name is \(avt)")
                storageRef.child(avt).getData(maxSize: INT64_MAX){ data, error in
                    if error != nil {
                        print("Error occurs: \(error?.localizedDescription)")
                    }
                    else if data != nil {
                        if let imageTemp = UIImage(data: data!) {
                            print("image available")
                            self.profilePic = imageTemp
                        }
                    }
                }
            }
        }
    }
    
    func printArray(array: [String]) {
        print("\n\n\n\nThis is content of array")
        for i in array {
            print(i)
        }
        
        print("End of array\n\n\n")
    }
    
    func grabPhoto(){
        //        if showingUser == nil {
        ref.child("userPicture/\(currentUser!)/fileOwned").observeSingleEvent(of: .value){ snapshot in
            for i in snapshot.children {
                if let i2 = (i as? DataSnapshot)?.value as? String {
                    self.imageNames.append(i2)
                }
            }
            
            self.printArray(array: self.imageNames)
            self.collectionView.reloadData()
            
            let val = self.imageNames.count - 1
            print("Val before run: \(val)")
            if val >= 0 {
                for i in 0...val{
                    storageRef.child(self.imageNames[i]).getData(maxSize: INT64_MAX){ data, error in
                        print("\nCurrently getting image: \(self.imageNames[i]) \n")
                        if error != nil {
                            print("\n\(self.imageNames[i]) error occur\n")
                        }
                        else if data != nil {
                            if let imageTemp = UIImage(data: data!) {
                                print("\n\(self.imageNames[i]) image is available\n")
                                self.originalArrImages[val - i] = imageTemp
                            }
                        }
                        
                        self.collectionView.reloadData()
                        if self.originalArrImages.count == self.imageNames.count{
                            self.refreshControl.endRefreshing()
                        }
                    }
                }
            }
            else {
                self.refreshControl.endRefreshing()
            }
        }
        //       }
        
        //        else {
        //            ref.child("userPicture/\(showingUser!)/Public").observeSingleEvent(of: .value){ snapshot in
        //                for i in snapshot.children {
        //                    if let i2 = (i as? DataSnapshot)?.value as? String {
        //                        self.imageNames.append(i2)
        //                    }
        //                }
        //
        //                self.collectionView.reloadData()
        //
        //                let val = self.imageNames.count - 1
        //                if val >= 0 {
        //                    for i in 0...val{
        //                        storageRef.child(self.imageNames[i]).getData(maxSize: INT64_MAX){ data, error in
        //                            print(self.imageNames[i], separator: "", terminator: " ")
        //                            if error != nil {
        //                                print("Error occurs")
        //                            }
        //                            else if data != nil {
        //                                if let imageTemp = UIImage(data: data!) {
        //                                    print("image available")
        //                                    self.originalArrImages[val - i] = imageTemp
        //                                }
        //                            }
        //
        //                            self.collectionView.reloadData()
        //                        }
        //                    }
        //                }
        //            }
        //        }
    }
    
    var imagePick = UIImagePickerController()
    
    @IBOutlet weak var uploadPhotoImageView: UIImageView!
    @IBOutlet weak var thisClassNavigationBar: UINavigationBar!
    
    @IBAction func uploadPicAvt(_ sender: Any) {
        func takePhoto() {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                imagePick.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePick.sourceType = UIImagePickerController.SourceType.camera
                imagePick.allowsEditing = false
                self.present(imagePick, animated: true, completion: nil)
                print("Here: \(String(describing: uploadPhotoImageView))")
            }
            
        }
        
        let actionsheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle:.actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler:{ (action:UIAlertAction) in self.imagePick.sourceType = .camera
            self.present(self.imagePick, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: {(action:UIAlertAction) in self.imagePick.sourceType = .photoLibrary
            self.present(self.imagePick, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
        
        
//        func imagePickerController(picker: UIImagePickerController,
//                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            guard let image = info[.originalImage] as? UIImage else {
//                print("Error")
//                return
//            }
//            avtImageView.image = image
//            picker.dismiss(animated: true, completion: nil)
//
//
//
//
//
////            if(choice == 1){
////                print("You choose upload photo from  ")
////                imagePick.dismiss(animated: true, completion: nil)
////                uploadPhotoImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
////                uploadPhoto()
////            }
////            if(choice == 2){
////                print("You choose take phote")
////                dismiss(animated: true, completion: nil)
////                takePhoto()
////            }
//        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    func uploadPhoto(){
        let gameKey = ref2?.child("Usershaha/account2").key
        let filename = "\(gameKey).png"
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        //Get user's to create or access user's folder to store images
        //                let userID = Auth.auth().currentUser!.uid
        let tempUserID = "user01"
        let fileref = Storage.storage().reference().child("/\(tempUserID)/test")
        let image = uploadPhotoImageView.image!
        //get the PNG data for this image
        //        let data = image.pngData()
        let imageData: Data = image.pngData()!
        fileref.putData(imageData, metadata: meta, completion: { (meta, error) in
            if error == nil {
                self.ref2?.child("Usershaha/account2/image/test").setValue("filename")
            }
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLeftBarAbleToShow {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
        else {
            thisClassNavigationBar.isHidden = true
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        sideView.isHidden = true
        super.viewDidDisappear(animated)
    }
    
    
    
    func grabPhotoFromLibrary(){
        //        let iM = PHImageManager.default()
        //        let iMRequest = PHImageRequestOptions()
        //        iMRequest.isSynchronous = true
        //        iMRequest.deliveryMode = .highQualityFormat
        //
        //        let fetchOptions = PHFetchOptions()
        //
        //        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        //
        //        if let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
        //            if fetchResult.count > 0  {
        //                for i in 0..<fetchResult.count {
        //                    iM.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: iMRequest, resultHandler: {
        //                        image , error in
        //
        //                        self.arrImages.append(image!)
        //                    })
        //                }
        //            }
        //            else {
        //                print("You dont have photo")
        //                self.collectionView.reloadData()
        //            }
        //        }
    }
    
    
//    func getImagesOfUser(){
//        let userID = Auth.auth().currentUser?.uid
//        ref.child("userPicture").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            let username = value?["username"] as? String ?? ""
//            let email = value?["email"] as? String ?? ""
//            let fullName = value?["fullName"] as? String ?? ""
//            let avtImage = value?["avtImage"] as? String ?? ""
//            //let arrImages: Dictionary = value?[""] as? Dictionary
//            //let user = User(id: userID!, email: email, fullName: fullName, avtImage: avtImage, arrImages: arrImages)
//
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func updateUI(){
        
//        avtImageView.layer.cornerRadius = avtImageView.frame.height / 2.0
//        avtImageView.layer.masksToBounds = true
//        uploadPhotoImageView.layer.cornerRadius = uploadPhotoImageView.frame.height/2
//        uploadPhotoImageView.layer.masksToBounds = true
        
    }
    
    @objc func removingSetting(sender: UITapGestureRecognizer? = nil){
        if menuShowing{
            sideView.isHidden = true
            sideViewLeadingContraint.constant = -200
        }
        else{
            sideView.isHidden = false
            sideViewLeadingContraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        menuShowing = !menuShowing
        
    }
    
    @IBAction func toggledTapped(_ sender: Any) {
        if menuShowing{
            
            sideView.isHidden = true
            sideViewLeadingContraint.constant = -200
            removingSettingView.removeGestureRecognizer(tap)
            
        }
        else{
            sideView.isHidden = false
            sideViewLeadingContraint.constant = 0
            removingSettingView.addGestureRecognizer(tap)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        menuShowing = !menuShowing
        
    }
    
    @IBAction func acountSettings(_ sender: UITapGestureRecognizer) {
   //     performSegue(withIdentifier: goToAccountSetting, sender: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let accountsettingVC = storyboard.instantiateViewController(withIdentifier: "AccountSettingViewController") as! AccountSettingViewController
        self.show(accountsettingVC, sender: nil)
    }
    
    @IBAction func appearanceTapped(_ sender: UITapGestureRecognizer) {
    //    performSegue(withIdentifier: goToAppearance, sender: self)
        let appearanceVC = storyboard?.instantiateViewController(withIdentifier: "AppearanceViewController") as! AppearanceViewController
        self.show(appearanceVC, sender: nil)
    }
    
//    @IBAction func staticTapped(_ sender: UITapGestureRecognizer) {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let aboutVC = storyboard.instantiateViewController(withIdentifier: "StatisticsViewController") as! StatisticsViewController
//        self.show(aboutVC, sender: nil)
//    }
    
    @IBAction func logoutTapped(_ sender: UITapGestureRecognizer) {
        do {
            try Auth.auth().signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            self.dismiss(animated: true, completion: nil)
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
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
    
    @IBAction func aboutTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let aboutVC = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        self.show(aboutVC, sender: nil)
    }
    
}

extension MainPersonalViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("number of sections")
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(originalArrImages.count) picture found")
        return originalArrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Cell for item at")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let customCell = cell as? PhotoCollectionViewCell {
            if indexPath.row < originalArrImages.count {
                print("customCell available")
                if !isNewest {
                    customCell.imageViewInCell.image = originalArrImages[originalArrImages.count - 1 - indexPath.row]
                }
                else {
                    customCell.imageViewInCell.image = originalArrImages[indexPath.row]
                }
                
                return customCell
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isNewest {
            performSegue(withIdentifier: fromPersonalToDetail, sender: (imageNames[originalArrImages.count - 1 - indexPath.row], originalArrImages[indexPath.row]))
        }
        else {
            performSegue(withIdentifier: fromPersonalToDetail, sender: (imageNames[indexPath.row], originalArrImages[originalArrImages.count - 1 - indexPath.row]))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == fromPersonalToDetail {
            if let dest = segue.destination as? DetailViewController {
                if let (name, image) = sender as? (String, UIImage) {
                    dest.image = image
                    dest.fileName = name
                }
            }
        }
    }
}

//extension MainPersonalViewController : LayoutDelegate {
//
//    // 1. Returns the photo height
//    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
//
//        return arrImages[indexPath.item]!.size.height
//    }
//
//}

extension MainPersonalViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (numberOfColumns + 1)
        let available = view.frame.width - paddingSpace
        let widthPerItem = available / numberOfColumns
        
        //print("IndexPath row is \(indexPath.row)")
        //print("imagePhoto has \(imagePhoto.count)\n")
        if indexPath.row < originalArrImages.count && originalArrImages[indexPath.row] != nil {
            //print("\(photoHeight)\t\(photoWidth)")
            
            return CGSize(width: widthPerItem, height: widthPerItem * ((originalArrImages[indexPath.row]?.size.height)! / (originalArrImages[indexPath.row]?.size.width)!))
        }
        else {
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}



extension MainPersonalViewController{
    
    @objc func sorting(_ sender: UIButton) {
        print("Sorting")
        
        let actionSheet = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Newest", style: .default){ (_) in
            print("Selecting newest")
            if !self.isNewest {
                self.isNewest = true
                self.collectionView.reloadData()
            }
        })
        
        actionSheet.addAction(UIAlertAction(title: "Oldest", style: .default){ (_) in
            if self.isNewest {
                print("Selecting oldest")
                self.isNewest = false
                self.collectionView.reloadData()
            }
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PersonalHeaderViewController", for: indexPath) as? PersonalHeaderViewController
                else {
                    fatalError("Invalid personal view type")
            }
            if showingUser == nil {
                headerView.usernameLabel.text = currentUser
                
            } else{
                headerView.usernameLabel.text = showingUser
                headerView.uploadPhotoImageView.isHidden = true
            }
            
            if profilePic == nil {
                print("Sorry it's nil")
            }
            headerView.avtImageView.image = profilePic
            
            headerView.layer.cornerRadius = headerView.avtImageView.frame.height / 2.0
            headerView.uploadPhotoImageView.layer.masksToBounds = true
            headerView.uploadPhotoImageView.layer.cornerRadius = headerView.uploadPhotoImageView.frame.height/2
            headerView.uploadPhotoImageView.layer.masksToBounds = true
            
            numberOfColumns = CGFloat(headerView.choiceOfColumns.selectedSegmentIndex+1)
            headerView.choiceOfColumns.addTarget(self, action: #selector(switchView(_:)), for: .valueChanged)
            
            headerView.sortButton.addTarget(self, action: #selector(sorting(_:)), for: .touchUpInside)
            
            return headerView
            
        default:
            assert(false, "invalid element type")
        }
    }
    
    
    
    
    
    
    
}
