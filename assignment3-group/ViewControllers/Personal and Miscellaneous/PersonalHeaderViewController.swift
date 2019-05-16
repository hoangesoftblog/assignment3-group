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
    
    @IBOutlet weak var additionalView: UIView!
    
    func changeBackground(image:UIImage){
        let frame : CGRect = topView.bounds
        let tempx : CGFloat = topView.frame.origin.x
        let tempy : CGFloat = topView.frame.origin.y
        let tempwidth : CGFloat =  frame.width
        let tempheight : CGFloat = frame.height
        let newheight : CGFloat = tempheight - 45
        let newRec : CGRect = CGRect(x: tempx, y: tempy, width: tempwidth, height: newheight)
        let backgroundImage = UIImageView(frame: newRec)
        backgroundImage.image = image
        backgroundImage.contentMode = .scaleToFill
        topView.insertSubview(backgroundImage, at: 0)
    }
//    @IBOutlet weak var backGroundButton: UIButton!
//
    
}
