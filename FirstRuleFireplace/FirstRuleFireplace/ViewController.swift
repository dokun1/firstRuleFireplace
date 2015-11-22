//
//  ViewController.swift
//  FirstRuleFireplace
//
//  Created by David Okun on 10/31/15.
//  Copyright © 2015 David Okun, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum VideoPlayingState {
        case videoOne
        case videoTwo
        case videoThree
    }
    
    var rainPlayer = AVAudioPlayer()
    var musicPlayer = AVAudioPlayer()
    var volumeGuideView = UIImageView(image: UIImage(named: "volumeAdjustment"))
    var appStarted = Bool()
    var currentVideoState = VideoPlayingState.videoOne
    
    var videoViewOne = VideoFactory.viewForVideo("fireplaceVideo")!
    var videoViewTwo = VideoFactory.viewForVideo("fireplaceVideo2")!
    var videoViewThree = VideoFactory.viewForVideo("fireplaceVideo3")!
    
    @IBOutlet weak var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var singleTapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var doubleTapRecognizer: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        startRainAudio()
        startMusicAudio()
        createVideoSubviews()
        singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appReopened", name: "appCameToLife", object: nil)
    }
    
    func appReopened() {
        if appStarted {
            reloadCurrentVideo()
        }
        appStarted = true
    }

    func startRainAudio() {
        let rainFilePath = NSBundle.mainBundle().pathForResource("rainyMood", ofType: "mp3")
        let fileURL = NSURL.fileURLWithPath(rainFilePath!)
        do {
            rainPlayer = try AVAudioPlayer.init(contentsOfURL: fileURL, fileTypeHint: AVFileTypeMPEGLayer3)
            rainPlayer.numberOfLoops = -1
            rainPlayer.volume = 0.85
        } catch {
            self.presentViewController(UIAlertController.init(title: "Error", message: "Could not play the rain. Sorry!", preferredStyle: .Alert), animated: true, completion: nil)
        }
        rainPlayer.play()
    }
    
    func startMusicAudio() {
        let godotFilePath = NSBundle.mainBundle().pathForResource("godotSong", ofType: "mp3")
        let fileURL = NSURL.fileURLWithPath(godotFilePath!)
        do {
            musicPlayer = try AVAudioPlayer.init(contentsOfURL: fileURL, fileTypeHint: AVFileTypeMPEGLayer3)
            musicPlayer.numberOfLoops = -1
            musicPlayer.volume = 0.85
        } catch {
            self.presentViewController(UIAlertController.init(title: "Error", message: "Could not play the music. Sorry!", preferredStyle: .Alert), animated: true, completion: nil)
        }
        musicPlayer.play()
    }
    
    func createVideoSubviews() {
        self.view.addSubview(videoViewOne)
        self.view.addSubview(videoViewTwo)
        self.view.addSubview(videoViewThree)
        
        self.view.bringSubviewToFront(videoViewOne)
        videoViewOne.videoPlayer.play()
        createVolumeGuide()
    }
    
    func reloadCurrentVideo() {
        switch currentVideoState {
        case .videoOne:
            videoViewOne.startVideo()
            videoViewTwo.stopVideo()
            videoViewThree.stopVideo()
            self.view.bringSubviewToFront(videoViewOne)
            break
        case .videoTwo:
            videoViewOne.stopVideo()
            videoViewTwo.startVideo()
            videoViewThree.stopVideo()
            self.view.bringSubviewToFront(videoViewTwo)
            break
        case .videoThree:
            videoViewOne.stopVideo()
            videoViewTwo.stopVideo()
            videoViewThree.startVideo()
            self.view.bringSubviewToFront(videoViewThree)
            break
        }
        self.view.bringSubviewToFront(volumeGuideView)
    }
    
    func createVolumeGuide() {
        volumeGuideView.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - 550, CGRectGetMinY(self.view.frame), 500, 500)
        volumeGuideView.contentMode = .ScaleAspectFit
        self.view.addSubview(volumeGuideView)
        self.view.bringSubviewToFront(volumeGuideView)
    }
    
    // MARK: Gesture-based IBActions
    
    @IBAction func volumeGuideToggled() {
        var newAlpha:CGFloat = 1.0
        if volumeGuideView.alpha > 0 {
            newAlpha = 0.0
        }
        UIView.animateWithDuration(0.3) { () -> Void in
            self.volumeGuideView.alpha = newAlpha
        }
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            let newVolume = VolumeController.adjustVolume(Float(translation.x), yMovement: Float(translation.y), musicVolume: self.musicPlayer.volume, rainVolume: self.rainPlayer.volume)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.musicPlayer.volume = newVolume.0
                self.rainPlayer.volume = newVolume.1
                recognizer.setTranslation(CGPointZero, inView: self.view)
            })
        }
    }
    
    @IBAction func handleDoubleTap() {
        switch currentVideoState {
        case .videoOne:
            videoViewTwo.startVideo()
            self.view.bringSubviewToFront(videoViewTwo)
            videoViewOne.stopVideo()
            videoViewThree.stopVideo()
            currentVideoState = VideoPlayingState.videoTwo
            break
        case .videoTwo:
            videoViewThree.startVideo()
            self.view.bringSubviewToFront(videoViewThree)
            videoViewTwo.stopVideo()
            videoViewOne.stopVideo()
            currentVideoState = VideoPlayingState.videoThree
            break
        case .videoThree:
            videoViewOne.startVideo()
            self.view.bringSubviewToFront(videoViewOne)
            videoViewTwo.stopVideo()
            videoViewThree.stopVideo()
            currentVideoState = VideoPlayingState.videoOne
            break
        }
        self.view.bringSubviewToFront(volumeGuideView)
    }
}