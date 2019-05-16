//
//  ForgetPasswordController.swift
//  assignment3-group
//
//  Created by vang huynh minh tri on 5/13/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class ForgetPasswordController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("yellow", forKey: "bgColor")
        guard let white: String = UserDefaults.standard.object(forKey: "bgColor") as? String else {return}
        if color == "white" {
            self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        print("went to forget")
        guard let color = UserDefaults.standard.object(forKey: "bgColor") as? String else {
            return
        }
        if color == "yellow" {
            self.view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        }
    }


    @IBAction func backToLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendToEmail(_ sender: Any) {
        let email = emailTextField.text
        print(email)
        sendPasswordReset(withEmail: email!)
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    


    
    func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }


}
