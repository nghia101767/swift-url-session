//
//  ApiResponse.swift
//  UrlSessionTutorial
//
//  Created by Nghia Nguyen on 8/6/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation
struct ApiResponse<T:Codable>:Codable {
    let error: Bool?
    let message: String?
    let data:T
     
    enum CodingKeys: String, CodingKey {
        case error = "error"
        case message = "message"
        case data = "data"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decode(Bool.self, forKey: .error)
        message = try values.decode(String.self, forKey: .message)
        data = try values.decode(T.self, forKey: .data)
    }
}
