//
//  VideoView.swift
//  FirstRuleFireplace
//
//  Created by David Okun on 11/22/15.
//  Copyright © 2015 David Okun, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class VideoView: UIView {
    var videoPlayer = AVPlayer()
    var isFront = Bool()
    
    required init(fileURL: NSURL, frame: CGRect) {
        super.init(frame: frame)
        videoPlayer = AVPlayer.init(URL: fileURL)
        let playerLayer = AVPlayerLayer.init(player: videoPlayer)
        playerLayer.frame = self.frame
        playerLayer.setNeedsDisplay()
        
        self.layer.addSublayer(playerLayer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoDidEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        videoPlayer.actionAtItemEnd = .None
    }
    
    func videoDidEnd(item: NSNotification) {
        videoPlayer.seekToTime(kCMTimeZero)
        if isFront {
            startVideo()
        }
    }
    
    func startVideo() {
        videoPlayer.play()
    }
    
    func stopVideo() {
        videoPlayer.pause()
        videoPlayer.seekToTime(kCMTimeZero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
