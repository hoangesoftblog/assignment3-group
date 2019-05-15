//
//  AccountInfoViewController.swift
//  assignment3-group
//
//  Created by Bui Thanh Khoi on 5/15/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit

class AccountInfoViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //AwesomePhoto logo at the center of navigaton bar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 23))
        imageView.image = #imageLiteral(resourceName: "awesome")
        navigationItem.titleView = imageView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(finishEditing))
    }
    
    @objc func finishEditing() {
        print("Button is pressed")
        self.navigationController?.popViewController(animated: true)
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
