//
//  Download.swift
//  UrlSessionTutorial
//
//  Created by Nghia Nguyen on 8/8/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

class Download {
    var isDownloading = false
    var track: Track
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var progress:Float = 0.0
    
    init(track: Track){
        self.track = track
    }
    
}
