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
    
    func changAvatarOnLocalAndFirebase(image:UIImage, fileLocation: URL){
        avtImageView.image = image
        
        //Put file to Database and Storage
        let fileNameOnDatabse = currentUser! + " " + fileLocation.lastPathComponent
        storageRef.child(fileNameOnDatabse).putFile(from: fileLocation)
        ref.child("userPicture/\(currentUser!)/avtImage").setValue(fileNameOnDatabse)
    }
    
    @IBOutlet weak var additionalView: UIView!
    
    func changeBackgroundOnLocalAndDatabse(image:UIImage, fileLocation: URL){
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
        
        //Put file to Database and Storage
        let fileNameToPut = currentUser! + " " + fileLocation.lastPathComponent
        storageRef.child(fileNameToPut).putFile(from: fileLocation)
        ref.child("userPicture/\(currentUser!)/backgroundImage").setValue(fileNameToPut)
    }
//    @IBOutlet weak var backGroundButton: UIButton!
//
    
}
