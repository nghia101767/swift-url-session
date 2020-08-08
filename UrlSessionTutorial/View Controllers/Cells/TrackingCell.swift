//
//  TrackingCellTableViewCell.swift
//  UrlSessionTutorial
//
//  Created by Nghia Nguyen on 8/6/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import UIKit

protocol TrackingCellDelegate {
    func cancelTapped(_ cell: TrackingCell)
    func downloadTapped(_ cell: TrackingCell)
    func pauseTapped(_ cell: TrackingCell)
    func resumeTapped(_ cell: TrackingCell)
    func playTapped(_ cell: TrackingCell)
}

class TrackingCell: UITableViewCell {
    
    static let identifier = "TrackingCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var singer: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var processingLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var delegate: TrackingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func doCancel(_ sender: UIButton) {
        delegate?.cancelTapped(self)
    }
    @IBAction func doDownload(_ sender: UIButton) {
        if sender.titleLabel?.text == "Play" {
            delegate?.playTapped(self)
        }else{
            delegate?.downloadTapped(self)
        }
    }
    @IBAction func doPause(_ sender: UIButton) {
        if sender.titleLabel?.text == "pause"{
            delegate?.pauseTapped(self)
        }else{
            delegate?.resumeTapped(self)
        }
    }
    func config(_ track: Track, _ downloaded: Bool) {
        let titleArr = track.title?.components(separatedBy: "-")
        if var titles = titleArr, titles.count > 0 {
            title.text = titles[0]
            titles.remove(at: 0)
            singer.text = titles.joined(separator: "-")
        }
        if downloaded {
            btnDownload.setTitle("Play", for: .normal)
            btnDownload.setTitleColor(.blue, for: .normal)
        }else{
            btnDownload.setTitle("Download", for: .normal)
            btnDownload.setTitleColor(.red, for: .normal)
        }
    }
    
}
