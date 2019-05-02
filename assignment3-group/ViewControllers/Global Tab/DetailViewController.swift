//
//  DetailViewController.swift
//  assignment3-group
//
//  Created by Hoang, Truong Quoc on 5/1/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    var fileName: String?
    var insetLeft: CGFloat = 20
    var insetTop: CGFloat = 20
    var image: UIImage?
    @IBOutlet weak var mainPic: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainPic.image = image
        print(image?.size)
        
        
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
