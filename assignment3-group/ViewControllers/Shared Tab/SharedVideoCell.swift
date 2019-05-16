//
//  SharedVideoCell.swift
//  assignment3-group
//
//  Created by Hoang, Truong Quoc on 5/10/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit

class SharedVideoCell: UICollectionViewCell {
    var roundNumber:CGFloat = 15
    @IBOutlet weak var thumbnailView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = roundNumber
        contentView.layer.masksToBounds = true
    }
}
