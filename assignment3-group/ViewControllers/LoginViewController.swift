//
//  LoginViewController.swift
//  AwesomePhoto
//
//  Created by Chau Phuoc Tuong on 4/4/19.
//  Copyright © 2019 Chau Phuoc Tuong. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var gmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateUI(){
        
    }
    
    @IBAction func login(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        if Auth.auth().currentUser == nil{
            Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] user, error in
                guard let strongSelf = self else { return }
                // ...
                if error == nil{
                    print("Login success")
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let mainTabbarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                    self?.navigationController?.pushViewController(mainTabbarController, animated: true)
                }else{
                    print(error?.localizedDescription)
                }
            }
        }
        
        print("Login in")
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
