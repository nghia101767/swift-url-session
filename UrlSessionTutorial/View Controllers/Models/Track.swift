//
//  Track.swift
//  UrlSessionTutorial
//
//  Created by Nghia Nguyen on 8/6/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

class Track: Codable {
    let title: String?
    let url:String
    var downloaded = false
    var index = -1
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case url = "url"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        url = try values.decode(String.self, forKey: .url)
    }
    func getUrl() -> URL{
        return URL(string: self.url)!
    }
}
