//
//  LoginViewController.swift
//  AwesomePhoto
//
//  Created by Chau Phuoc Tuong on 4/4/19.
//  Copyright © 2019 Chau Phuoc Tuong. All rights reserved.
//

import UIKit
import Firebase

var currentUser: String?

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var gmailButton: UIButton!
    
    func goToMain(){
        performSegue(withIdentifier: "goToMain", sender: self)
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
        
    }
    
    @IBAction func gmailTapped(_ sender: Any) {
        
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
