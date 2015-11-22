//
//  VolumeController.swift
//  FirstRuleFireplace
//
//  Created by David Okun on 11/7/15.
//  Copyright © 2015 David Okun, LLC. All rights reserved.
//

import UIKit

class VolumeController: NSObject {
    
    class func adjustVolume(xMovement: Float, yMovement:Float, musicVolume: Float, rainVolume: Float) -> (musicVolume: Float, rainVolume: Float) {
        
        let adjustmentFactor:Float = 5500
        let minimumTranslationThreshold:Float = 6.999  // haha lol 69

        var newMusicVolume:Float = musicVolume
        var newRainVolume:Float = rainVolume
        
        if fabsf(xMovement) > minimumTranslationThreshold {
            newMusicVolume = newMusicVolume + (xMovement/adjustmentFactor)
            if newMusicVolume > 1 {
                newMusicVolume = 1.00
            }
            if newMusicVolume < 0 {
                newMusicVolume = 0.00
            }
        }
        
        if fabsf(yMovement) > minimumTranslationThreshold {
            newRainVolume = newRainVolume - (yMovement/adjustmentFactor)
            if newRainVolume > 1 {
                newRainVolume = 1.00
            }
            if newRainVolume < 0 {
                newRainVolume = 0.00
            }
        }
        return (newMusicVolume, newRainVolume)
    }
}