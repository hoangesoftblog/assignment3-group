//
//  Multimedia.swift
//  assignment3-group
//
//  Created by namtranx on 4/25/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import Foundation
import UIKit


struct Multimedia {
    let name: String!
    let url: String!
    let watermark: Bool!
    
    init() {
        self.name = ""
        self.url = ""
        self.watermark = false
    }
    
    init(name: String, url: String, watermark: Bool) {
        self.name = name
        self.url = url
        self.watermark = watermark
    }
}


