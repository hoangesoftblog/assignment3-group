//
//  EnterUsernameViewController.swift
//  assignment3-group
//
//  Created by hoang on 5/10/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit
import Firebase

class EnterUsernameViewController: UIViewController {
    
    let goToMain = "goToMain"
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("yellow", forKey: "bgColor")
        guard let white: String = UserDefaults.standard.object(forKey: "bgColor") as? String else {return}
        if white == "white" {
            self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
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
