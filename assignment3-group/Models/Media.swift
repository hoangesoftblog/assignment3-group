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

class Media{
    static func getFileName(fileName: String){
        
    }
    
    private static func getReference(info needed: String){
        ref.child(needed).observeSingleEvent(of: .value){ snapshot in
                        
        }
    }
}
