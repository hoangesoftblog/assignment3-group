import UIKit
import Firebase
import Photos

private let reuseIdentifier = "personalCollectionViewCell"

class MainPersonalViewController: UIViewController, UICollectionViewDelegateFlowLayout{
    
    let goToAccountSetting = "goToAccountSetting"
    let goToAppearance = "goToAppearance"
    let goToStatistic = "goToStatistic"
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var jobLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var avtImageView: UIImageView!
    
    @IBOutlet weak var uploadPhotoImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var sideViewLeadingContraint: NSLayoutConstraint!
    
    var menuShowing: Bool = false
    
    var arrImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = currentUser
        
        //        ref.child("userPicture/\(currentUser)").observeSingleEvent(of: .value){ snapshot in
        //            if let val = snapshot.value as? [String: Any] {
        //                if let avtName = val["avtImage"] as? String{
        //                    storageRef.child(avtName).getData(maxSize: INT64_MAX){ data, error in
        //                        print(avtName + " is get")
        //                        if error != nil {
        //                            print("Error occurs")
        //                        }
        //                        else if data != nil {
        //                            if let imageTemp = UIImage(data: data!) {
        //                                print("image available")
        //                                self.avtImageView.image = imageTemp
        //                            }
        //                        }
        //                    }
        //                }
        //
        //                self.jobLabel.text = ((val["job"] as? String) ?? "Traveler")
        //            }
        //        }
        
        updateUI()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        grabPhoto()
        if let layout = collectionView?.collectionViewLayout as? CollectionViewPhotoLayout {
            layout.delegate = self as? LayoutDelegate
            
        }
        
    }
    
    func grabPhoto(){
        let iM = PHImageManager.default()
        let iMRequest = PHImageRequestOptions()
        iMRequest.isSynchronous = true
        iMRequest.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            if fetchResult.count > 0  {
                for i in 0..<fetchResult.count {
                    iM.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: iMRequest, resultHandler: {
                        image , error in
                        
                        self.arrImages.append(image!)
                    })
                }
            }
            else {
                print("You dont have photo")
                self.collectionView.reloadData()
            }
        }
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
        
        avtImageView.layer.cornerRadius = avtImageView.frame.height / 2.0
        avtImageView.layer.masksToBounds = true
        uploadPhotoImageView.layer.cornerRadius = uploadPhotoImageView.frame.height/2
        uploadPhotoImageView.layer.masksToBounds = true
        
    }
    
    @IBAction func toggledTapped(_ sender: Any) {
        if menuShowing{
            sideViewLeadingContraint.constant = -200
        }else{
            sideViewLeadingContraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        menuShowing = !menuShowing
        
    }
    
    @IBAction func acountSettings(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: goToAccountSetting, sender: self)
    }
    
    @IBAction func appearanceTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: goToAppearance, sender: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let aboutVC = storyboard.instantiateViewController(withIdentifier:"MainPersonalViewController") as! MainPersonalViewController
        
    }
    
    @IBAction func staticTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let aboutVC = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        self.show(aboutVC, sender: nil)
    }
    
    
    
    @IBAction func aboutTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let aboutVC = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        self.show(aboutVC, sender: nil)
    }
    
 
    @IBAction func editTapped(_ sender: Any) {
        print("edit bg")
        //code...
        var bgViewLayer = CALayer()
        let image = UIImage(named: "logo")
        bgViewLayer.frame = topView.bounds
        bgViewLayer.contents = image
        topView.layer.addSublayer(bgViewLayer)
        
        let alertController = UIAlertController(title: " Thông báo", message: "Bạn muốn chọn chế độ nào ?", preferredStyle: .alert)
        let imgPicker = UIImagePickerController()
        
        // Adding photo-button into the alert
        let photoAction = UIAlertAction(title: "Photo", style: UIAlertAction.Style.default) { (UIAlertAction) in
            imgPicker.allowsEditing = true
            imgPicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imgPicker.sourceType = .photoLibrary
            self.present(imgPicker, animated: true, completion: nil)
        }
        
        alertController.addAction(photoAction)
        
        // Asking for taking photo - can enable or not
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                imgPicker.allowsEditing = true
                imgPicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imgPicker.sourceType = .camera
                self.present(imgPicker, animated: true, completion: nil)
            }else{
                print("No detect camera")
            }
            
        }
        
        alertController.addAction(cameraAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
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
    
}

extension MainPersonalViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.image.image = arrImages[indexPath.row]
        return cell
    }
    
    
}

extension MainPersonalViewController : LayoutDelegate {
    
    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        return arrImages[indexPath.item].size.height
}

}
