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
    let id: String!
    let url: String!
    let watermark: Bool!
    
    init() {
        self.id = ""
        self.url = ""
        self.watermark = false
    }
    
    init(id: String, url: String, watermark: Bool) {
        self.id = id
        self.url = url
        self.watermark = watermark
    }
}
