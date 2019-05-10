//
//  AccountSettingViewController.swift
//  assignment3-group
//
//  Created by Chau Phuoc Tuong on 5/8/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountSettingViewController: UIViewController {
    
    
    
    
    @IBAction func deleteAccount(_ sender: Any) {
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                // An error happened.
            } else {
                // Account deleted.
            }
        }
    }
    
  
    @IBAction func autoSaveTapped(_ sender: Any) {
        UserDefaults.standard.set("on", forKey: "autosave")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let color: String = UserDefaults.standard.object(forKey: "bgColor") as? String else {return
            
        }
        let autosave = UserDefaults.standard.set("on", forKey: "autosave") as! String
        if autosave == "on" {
            
        } else {
            // show alert confirm save k?
            // alertaction: Save
        }

        // Do any additional setup after loading the view.
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
