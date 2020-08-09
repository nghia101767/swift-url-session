//
//  ViewController.swift
//  UrlSessionTutorial
//
//  Created by Nghia Nguyen on 8/6/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class SearchViewController: UIViewController {

    let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    let queryService = QueryService()
    let downloadService = DownloadService()
    
    lazy var downloadsSession: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchResult: [Track] = []
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    
    func localPath(for url:URL)->URL{
        return documentPath.appendingPathComponent(url.lastPathComponent)
    }
    func position(for bar: UIBarPosition) -> UIBarPosition{
        return .topAttached
    }
    func reload(_ row: Int){
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        downloadService.downloadsSession = downloadsSession
    }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    func playDownload(_ track: Track){
        print("avplaying")
//        let player = AVPlayerViewController()
//        present(player, animated: true, completion: nil)
//        let url = localPath(for: track.)
    }

}


extension SearchViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        queryService.getResult(searchText){[weak self] results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let results = results {
                self?.searchResult = results
                self?.tableView.reloadData()
                self?.tableView.setContentOffset(.zero, animated: false)
            }
            if !errorMessage.isEmpty{
                print("Search error: \(errorMessage)")
            }
            
        }
        
    }
    
}

extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackingCell.identifier, for: indexPath) as! TrackingCell
        cell.delegate = self
        let track = searchResult[indexPath.row]
        cell.config(track, track.downloaded)
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = searchResult[indexPath.row]
        if track.downloaded {
            playDownload(track)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
}

extension SearchViewController: TrackingCellDelegate{
    func cancelTapped(_ cell: TrackingCell) {
        if let indexPath = tableView.indexPath(for: cell){
            let track = searchResult[indexPath.row]
            downloadService.cancelDownload(track)
            reload(indexPath.row)
        }
    }
    
    func downloadTapped(_ cell: TrackingCell) {
        if let indexPath = tableView.indexPath(for: cell){
            let track = searchResult[indexPath.row]
            downloadService.startDownload(track)
            reload(indexPath.row)
        }
    }
    
    func pauseTapped(_ cell: TrackingCell) {
        if let indexPath = tableView.indexPath(for: cell){
            let track = searchResult[indexPath.row]
            downloadService.pauseDownload(track)
            reload(indexPath.row)
        }
    }
    
    func resumeTapped(_ cell: TrackingCell) {
        if let indexPath = tableView.indexPath(for: cell){
            let track = searchResult[indexPath.row]
            downloadService.resumeDownload(track)
            reload(indexPath.row)
        }
    }
    
    func playTapped(_ cell: TrackingCell) {
        print("play 153")
    }
    
    
}


extension SearchViewController: URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finish download \(location)")
    }
}
