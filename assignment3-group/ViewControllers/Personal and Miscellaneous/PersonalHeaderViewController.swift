//
//  PersonalHeaderViewController.swift
//  assignment3-group
//
//  Created by Khánh Đặng on 5/13/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit

class PersonalHeaderViewController: UICollectionReusableView {
    
    @IBOutlet weak var topView: UIView!
    
  
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var jobLabel: UILabel!
    
    @IBOutlet weak var choiceOfColumns: UISegmentedControl!
    
    
    @IBOutlet weak var avtImageView: UIImageView!
    
    
    @IBOutlet weak var uploadPhotoImageView: UIImageView!
    
    @IBOutlet weak var changeBackgroundBt: UIButton!
    
    @IBOutlet weak var sortButton: UIButton!
    
    func changAvatar(image:UIImage){
        avtImageView.image = image
    }
    
    func changeBackground(image:UIImage){
        let backgroundImage = UIImageView(frame: topView.bounds)
        backgroundImage.image = image
        backgroundImage.contentMode = .scaleToFill
        topView.insertSubview(backgroundImage, at: 0)
    }
//    @IBOutlet weak var backGroundButton: UIButton!
//
    
}
