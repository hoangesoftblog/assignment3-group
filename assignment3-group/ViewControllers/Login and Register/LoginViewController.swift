//
//  LoginViewController.swift
//  AwesomePhoto
//
//  Created by Chau Phuoc Tuong on 4/4/19.
//  Copyright © 2019 Chau Phuoc Tuong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

var currentUser: String?

class LoginViewController: UIViewController, FUIAuthDelegate, FBSDKLoginButtonDelegate   {
    let enterUsername = "enterUsername"
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult, error: Error!) {
        print("running")
//        print(error.localizedDescription)
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        print("credential: \(credential)")
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print(credential)
            ref.child("IDToUser").observeSingleEvent(of: .value){ snapshot in
                if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                    currentUser = snapshot.childSnapshot(forPath: Auth.auth().currentUser!.uid).value as? String
                    self.goToMain()
                }
                else {
                    self.performSegue(withIdentifier: self.enterUsername, sender: self)
                }
            }

            
            // User is signed in
            // ...
        }
        
        if let error = error {
//            print("running2)
            print(error.localizedDescription)
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            print("credential: \(credential)")
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                print(credential)
                // User is signed in
                // ...
            }
            return
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("user logout")
    }
    
//FBSDKLoginButtonDelegate
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var gmailButton: UIButton!
    var authUI : FUIAuth?
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error == nil {
            print("log in with Google Acccount")
        }
    }
    
    @IBAction func logInWithGoogle(_ sender: Any) {
//        currentUser = nil
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
    
    
    func goToMain(){
        print(currentUser ?? "Not have yet")
        performSegue(withIdentifier: "goToMain", sender: self)
    }
//    func goToRegister(){
//        print(currentUser ?? "Not have yet")
//        performSegue(withIdentifier: "goToMain", sender: self)
//    }
    
    @IBAction func tapRegister(_ sender: Any) {
        performSegue(withIdentifier: "RegisterSegue", sender: self)
    }
    func getCurrentUsername(user: User){
        ref.child("IDToUser/\(user.uid)").observeSingleEvent(of: .value){ snapshot in
            if let name = snapshot.value as? String {
                currentUser = name
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers : [FUIAuthProvider] = [FUIGoogleAuth()]
        authUI?.providers = providers
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
//        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser {
            getCurrentUsername(user: user)
            print("Already login")
            goToMain()
        }
    }
    
    
    
    @IBAction func login(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        if Auth.auth().currentUser == nil {
            Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] user, error in
                guard let strongSelf = self else { return }
                // ...
                if error == nil{
                    print("Login success")
                    self?.getCurrentUsername(user: user!.user)
                    self?.goToMain()
                }
                else {
                    print(error?.localizedDescription)
                }
            }
        }
        else {
            self.getCurrentUsername(user: Auth.auth().currentUser!)
            print("Already login click on Login button")
            goToMain()
        }
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
//        let loginButton = FBSDKLoginButton()
//        loginButton.delegate = self as! FBSDKLoginButtonDelegate
    }
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if let error = error {
//            print(error.localizedDescription)
//            return
//        }
//        // ...
//    }
    @IBAction func gmailTapped(_ sender: Any) {
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
