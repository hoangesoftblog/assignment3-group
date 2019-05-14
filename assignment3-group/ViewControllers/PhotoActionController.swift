//
//  PhotoActionController.swift
//  assignment3-group
//
//  Created by vang huynh minh tri on 5/13/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import Foundation
import UIKit
class PhotoActionController : UIViewController {
   
    @IBOutlet weak var videoLarge: VideoPlayer!
    @IBOutlet weak var imageLarge: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    var image : UIImage?
    

  
    @IBOutlet weak var publicText: UILabel!
    @IBOutlet weak var privateText: UILabel!
    @IBOutlet weak var privacySwitch: UISwitch!
    

    
    @IBAction func checkSwitch(_ sender: Any) {
        if privacySwitch.isOn {
            print("UISwitch is ON")
            privateText.isHidden = true
            publicText.isHidden = false
        } else {
            print("UISwitch is OFF")
            privateText.isHidden = false
            publicText.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("got here")
        imageView.image = image
        videoLarge.isHidden = true
        imageLarge.image = image
        privateText.isHidden = true
    }
}
