//
//  DownloadService.swift
//  UrlSessionTutorial
//
//  Created by Nghia Nguyen on 8/6/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

class DownloadService {
    //
    // MARK: - Variables And Properties
    //
    var activeDownload: [URL:Download] = [:]
    /// SearchViewController creates downloadsSession
    var downloadsSession: URLSession!
    
    //
    // MARK: - Internal Methods
    //
    // TODO 9
    func cancelDownload(_ track: Track) {
    }
    
    // TODO 10
    func pauseDownload(_ track: Track) {
    }
    
    // TODO 11
    func resumeDownload(_ track: Track) {
    }
    
    // TODO 8
    func startDownload(_ track: Track) {
        let download = Download(track: track)
        download.task = downloadsSession.downloadTask(with: track.getUrl())
        download.task?.resume()
        download.isDownloading = true
        activeDownload[track.getUrl()] = download
    }
}
