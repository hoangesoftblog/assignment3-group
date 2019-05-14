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
        print("went to forget")
    }

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func send(_ sender: Any) {
        let email = emailTextField.text
        print(email)
        sendPasswordReset(withEmail: email!)
    }

    
    func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }




}
