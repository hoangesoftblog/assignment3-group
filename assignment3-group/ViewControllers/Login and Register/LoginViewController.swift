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
let forgetPasswordSegue = "ForgetPassword"
class LoginViewController: UIViewController, FUIAuthDelegate, FBSDKLoginButtonDelegate   {
    @IBAction func forgetPasswordClicked(_ sender: Any) {
        performSegue(withIdentifier: forgetPasswordSegue, sender: sender)
    }
    let enterUsername = "enterUsername"

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult, error: Error!) {
        print("running")
//        print(error.localizedDescription)
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current()?.tokenString ?? "no")
        //        if(credential != nil){
//        print("credential: \(credential)")
        getFBInfo()
        getFBUserData()
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    var authUI : FUIAuth?
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error == nil {
            if(currentUser == nil){
                            getCurrentUsername(user: Auth.auth().currentUser!)
            }

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
    
    @IBAction func registerClicked(_ sender: Any) {
        performSegue(withIdentifier: "registerSegue", sender: self)
    }
    
    func getFBUserData()
    {
        let graphPath = "me"
        let parameters = ["fields": "email"]
        let completionHandler = { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("This is result: \(result)")
//                print(json["email"].stringValue)
            }
        }
        let graphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: parameters)
//        graphRequest!.startWithCompletionHandler(completionHandler)
    }
    
    func getFBInfo(){
        print("checking token")
        if((FBSDKAccessToken.current()) != nil)
        {
            print("have token")
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, first_name, last_name, picture.type(large), email"]).start(completionHandler:
                { (connection, result, error) -> Void in
                    if (error == nil)
                    {
                        print(result)
                        //everything works print the user data
                        //                        print(result!)
                        if let data = result as? NSDictionary
                        {
                            let firstName  = data.object(forKey: "first_name") as? String
                            let lastName  = data.object(forKey: "last_name") as? String
                            
                            if let email = data.object(forKey: "email") as? String
                            {
                                print(email)
                            }
                            else
                            {
                                // If user have signup with mobile number you are not able to get their email address
                                print("We are unable to access Facebook account details, please use other sign in methods.")
                            }
                        }
                    }
            })
        }
    }
    
    @IBAction func forgetPassword(_ sender: Any) {
        let email = emailTextField.text
        sendPasswordReset(withEmail: email!)
    }
    
    func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }
    
//    @IBAction func forgetPasswordClicked(_ sender: Any) {
//        performSegue(withIdentifier: "forgetPasswordSegue", sender: self)
//    }
    @IBAction func goToRegister(_ sender: Any) {
        print("Go to register view")
        performSegue(withIdentifier: "RegisterSegue", sender: self)
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
        
        //Delegate text field
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        if let user = Auth.auth().currentUser {
            getCurrentUsername(user: user)
            print("Already login")
            goToMain()
        }
    }
    
    
    
    @IBAction func login(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        view.endEditing(true)
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
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current()?.tokenString ?? "no")
                //        if(credential != nil){
                //        print("credential: \(credential)")
                self.getFBInfo()
                self.getFBUserData()
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
//                if(fbloginresult.grantedPermissions.contains("email"))
//                {
//                    self.getFBUserData2()
//                }
            }
        }
    }
    func getFBUserData2(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result)
                }
            })
        }
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
