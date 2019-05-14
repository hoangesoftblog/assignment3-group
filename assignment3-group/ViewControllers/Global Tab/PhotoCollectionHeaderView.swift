//
//  PhotoCollectionHeaderView.swift
//  
//
//  Created by Hoang, Truong Quoc on 5/1/19.
//

import UIKit

class PhotoCollectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    
    
    @IBAction func button1Clicked(_ sender: Any) {
        button1.isSelected = true
        button2.isSelected = false
    }
    
    
    @IBAction func button2Clicked(_ sender: Any) {
        button1.isSelected = false
        button2.isSelected = true
    }
}
