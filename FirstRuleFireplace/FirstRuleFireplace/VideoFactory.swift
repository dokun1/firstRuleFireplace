//
//  VideoFactory.swift
//  FirstRuleFireplace
//
//  Created by David Okun on 11/22/15.
//  Copyright © 2015 David Okun, LLC. All rights reserved.
//

import UIKit

class VideoFactory: NSObject {
    class func viewForVideo(fileName: String) -> VideoView? {
        let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "mp4")
        if filePath == nil {
            return nil
        }
        let fileURL = NSURL.fileURLWithPath(filePath!)
        return VideoView.init(fileURL: fileURL, frame: UIScreen.mainScreen().bounds)
    }
}