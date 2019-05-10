//
//  VideoPlayerClass.swift
//  assignment3-group
//
//  Created by hoang on 5/8/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import AVFoundation
import UIKit
import AVKit

class VideoPlayer: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
}
