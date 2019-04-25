//
//  MainHomeViewController.swift
//  AwesomePhoto
//
//  Created by Chau Phuoc Tuong on 4/21/19.
//  Copyright © 2019 Chau Phuoc Tuong. All rights reserved.
//

import UIKit
import Firebase

let ref: DatabaseReference = Database.database().reference()

var images: [String] = []

class MainHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
    }
    
    //get data of all images from firebase
    func getData(){
        // Listen for new comments in the Firebase database
        ref.observe(.value, with: { (snapshot) -> Void in
            if let value = snapshot.value as? [String: Any]{
                let imageString = value["url"] as? String ?? ""
                images.append(imageString)
            }
            
        })
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
