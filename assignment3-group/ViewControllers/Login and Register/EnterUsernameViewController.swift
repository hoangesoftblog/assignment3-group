//
//  EnterUsernameViewController.swift
//  assignment3-group
//
//  Created by hoang on 5/10/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit
import Firebase

class EnterUsernameViewController: UIViewController, UITextFieldDelegate {
    
    let goToMain = "goToMain"
    @IBOutlet weak var username: UITextField!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func enterClicked(_ sender: Any) {
        if let text = username.text {
            currentUser = text
            ref.child("IDToUser/\(Auth.auth().currentUser!.uid)").setValue(text)
            print("New username set. Current user now is \(currentUser)")
            performSegue(withIdentifier: goToMain, sender: self)
        }
        else {
            print("Nothing enter.")
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
