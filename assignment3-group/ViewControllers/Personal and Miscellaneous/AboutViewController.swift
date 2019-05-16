//
//  AboutViewController.swift
//  assignment3-group
//
//  Created by Chau Phuoc Tuong on 4/24/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let color = UserDefaults.standard.object(forKey: "bgColor") as? String else {
            return
        }
        if color == "yellow" {
            self.view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
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
