//
//  PlayerView.swift
//  InstaClone
//
//  Created by Iksang Yoo on 2022/08/15.
//
// https://developer.apple.com/documentation/avfoundation/avplayerlayer

import UIKit
import AVFoundation

class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
