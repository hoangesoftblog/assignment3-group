//
//  User.swift
//  assignment3-group
//
//  Created by namtranx on 4/25/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let id:String!
    let email: String!
    let fullName: String!
    let avtImage: UIImage!
    let arrImages: [UIImage]!
    
    init() {
        self.id = ""
        self.email = ""
        self.fullName = ""
        self.avtImage = UIImage(named: "blabla")
        self.arrImages = []
    }
    
    init(id: String, email: String, fullName: String, avtImage: UIImage, arrImages: [UIImage]) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.avtImage = avtImage
        self.arrImages = arrImages
    }
}
