//
//  MainPaymentViewController.swift
//  AwesomePhoto
//
//  Created by Chau Phuoc Tuong on 4/21/19.
//  Copyright © 2019 Chau Phuoc Tuong. All rights reserved.
//

import UIKit
import Firebase

class MainPaymentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.child("userPicture/\(currentUser)/notification").observeSingleEvent(of: .value){ snapshot in
            for i in snapshot.children {
                if let i2 = i as? DataSnapshot {
                    
                }
            }
        }
        
    }

    

}


