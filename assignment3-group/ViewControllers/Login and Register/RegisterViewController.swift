//
//  ViewController.swift
//  AwesomePhoto
//
//  Created by Chau Phuoc Tuong on 3/26/19.
//  Copyright © 2019 Chau Phuoc Tuong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseUI
import GoogleSignIn
let storage = Storage.storage()

var storageRef = storage.reference()

class RegisterViewController: UIViewController, FUIAuthDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var rePassWordTextField: UITextField!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var avtImageView: UIImageView!
    
    var imgData:Data!
    var authUI : FUIAuth?
    
    @IBAction func signUpTapped(_ sender: Any) {
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (rePassWordTextField.text?.isEmpty)! || (fullNameTextField.text?.isEmpty)!{
            let alert = UIAlertController(title: "Cảnh báo", message: "Không được bỏ trống", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }else{
            guard let email = emailTextField.text, let password = passwordTextField.text, email.isValidEmail() else {
                print("email, password can not be empty")
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if error == nil{
                    print("Sign up success")
                    
                    //sign in
                    Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                        if error == nil{
                            print("sign in success")
                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let tabBarViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! MainTabBarViewController
                            self?.show(tabBarViewController, sender: nil)
                        }
                        else{
                            print(error?.localizedDescription)
                        }
                        
                    }
                    
                    let userNameFolder: String = email
                    let avtRef = storageRef.child("\(userNameFolder)/\(email).jpg")
                    ///////////////////////////////////////////
                    //water mark image before upload to firebase
                    
                    //////////////////////////////
                    
                    // Upload the file to the path "images/rivers.jpg"
                    let uploadTask = avtRef.putData(self.imgData, metadata: nil) { (metadata, error) in
                        guard let metadata = metadata else {
                            // Uh-oh, an error occurred!
                            print(error!.localizedDescription)
                            return
                        }
                        // Metadata contains file metadata such as size, content-type.
                        let size = metadata.size
                        // You can also access to download URL after upload.
                        avtRef.downloadURL { (url, error) in
                            guard let downloadURL = url else {
                                // Uh-oh, an error occurred!
                                return
                            }
                            //get current user
                            let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                                // ...
                                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                changeRequest?.displayName = self.fullNameTextField.text
                                changeRequest?.photoURL = downloadURL
                                changeRequest?.commitChanges { (error) in
                                    // ...
                                    if error == nil{
                                        print("upload success")
                                    }
                                    else{
                                        print(error?.localizedDescription)
                                    }
                                }
                            }
                        }
                    }
                    // uploading task on firebase
                    uploadTask.resume()
                }
                else{
                    print("Error sign up \(error?.localizedDescription)")
                }
            }
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error == nil {
            print("log in with Google Acccount")
        }
    }
    
    @IBAction func tapRegisterWithGoogle(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            if let authVC = authUI?.authViewController() {
                present(authVC, animated: true, completion: nil)
            }
            //            if let email = tfEmail.text, let password = tfPassword.text {
            //                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            //                    if error == nil {
            //                        self.btnLogin.setTitle("Logout", for: .normal)
            //                    }
            //                })
            //            }
        }
    }
    
    @IBAction func chooseModeAvt(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: " Thông báo", message: "Bạn muốn chọn chế độ nào ?", preferredStyle: .alert)
        let imgPicker = UIImagePickerController()
        
       // Adding photo-button into the alert
        let photoAction = UIAlertAction(title: "Photo", style: UIAlertAction.Style.default) { (UIAlertAction) in
            imgPicker.allowsEditing = true
            imgPicker.delegate = self
            imgPicker.sourceType = .photoLibrary
            self.present(imgPicker, animated: true, completion: nil)
        }
        
        alertController.addAction(photoAction)
        
     // Asking for taking photo - can enable or not
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                imgPicker.allowsEditing = true
                imgPicker.delegate = self
                imgPicker.sourceType = .camera
                self.present(imgPicker, animated: true, completion: nil)
            }else{
                print("No detect camera")
            }
            
        }
        
        alertController.addAction(cameraAction)
        self.present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imgData = UIImage.pngData(UIImage(named: "Camera-photo.svg")!)()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers : [FUIAuthProvider] = [FUIGoogleAuth()]
        authUI?.providers = providers
        
    }
    
    
}
// Taking picture in the library and setting the value (size) for image
extension RegisterViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chooseImg = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imgValue = max(chooseImg.size.width, chooseImg.size.height)
        if imgValue > 3000{
            imgData = UIImage.jpegData(chooseImg)(compressionQuality: 0.1) as? Data
        }
        else if imgValue > 2000{
            imgData = UIImage.jpegData(chooseImg)(compressionQuality: 0.3) as? Data
        }
        else{
            imgData = UIImage.pngData(chooseImg) as? Data
        }
        
        avtImageView.image = UIImage(data: imgData)
        dismiss(animated: true, completion: nil)
    }
   
}
// Checking the format of email is right or wrong
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
