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
    
    @IBAction func button2Action(_ sender: Any) {
        print("This is 2")
        button2.isEnabled = false
        button1.isEnabled = true
    }
    
    @IBAction func button1Action(_ sender: Any) {
        print("This is 1")
        button1.isEnabled = false
        button2.isEnabled = true
    }
}
