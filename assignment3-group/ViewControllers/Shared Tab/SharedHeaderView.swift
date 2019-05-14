//
//  SharedReusableView.swift
//  assignment3-group
//
//  Created by Hoang, Truong Quoc on 5/10/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit

class SharedHeaderView: UICollectionReusableView {
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
