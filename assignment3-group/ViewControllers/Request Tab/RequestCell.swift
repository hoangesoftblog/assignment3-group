//
//  RequestCell.swift
//  assignment3-group
//
//  Created by Khánh Đặng on 5/8/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
