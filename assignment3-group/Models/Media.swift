//
//  Media.swift
//  assignment3-group
//
//  Created by Hoang, Truong Quoc on 5/2/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import Foundation
import Firebase

let userToIDChild = "userToID"

class Media {
    
    static func removeFileExtension(file name: String) -> String {
        if let i = name.lastIndex(of: "."){
            var a = name
            a.removeSubrange(i..<a.endIndex)
            return a
        }
        else {
            return name
        }
        
    }
    
}
