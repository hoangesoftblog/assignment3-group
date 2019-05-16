//
//  SharedPhotoViewCell.swift
//  assignment3-group
//
//  Created by hoang on 5/3/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit

class SharedPhotoViewCell: UICollectionViewCell {
        var roundNumber:CGFloat = 15
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = roundNumber
        contentView.layer.masksToBounds = true
    }
}
