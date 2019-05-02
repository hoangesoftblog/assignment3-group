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
    
    static func getFileName(fileName: String) -> String {
        var res = fileName
        ref.child("fileName/\(fileName)").observeSingleEvent(of: .value){ snapshot in
            if let temp = snapshot.value as? [String: Any] {
                if let fileExtension = temp["extension"] as? String {
                    print(fileExtension)
                    res += ".\(fileExtension)"
                }
            }
        }
        return res
    }
    
    
}
