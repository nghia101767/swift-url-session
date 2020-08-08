//
//  QueryService.swift
//  UrlSessionTutorial
//
//  Created by Nghia Nguyen on 8/6/20.
//  Copyright © 2020 Nghia Nguyen. All rights reserved.
//

import Foundation

class QueryService {
    let api = "https://nguyenhuunghia.xyz/api/v1/p.php"
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    private var tracks:[Track] = []
    private var errorMessage = ""
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Track]?, String)->Void
    
    func getResult(_ key: String, completion: @escaping QueryResult) {
        dataTask?.cancel()
        if let urlComponents = URLComponents(string: api){
//            urlComponents.query = "a=b&c=d"
            guard let url = urlComponents.url else {return}
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            dataTask = defaultSession.dataTask(with: urlRequest){ [weak self] data, response, error in
                defer {self?.dataTask = nil}
                if let error = error{
                    self?.errorMessage = error.localizedDescription
                    
                }else if
                let data = data,
                let response = response as? HTTPURLResponse,
                    response.statusCode == 200{
                    self?.updateResult(data)
                    DispatchQueue.main.async {
                        completion(self?.tracks, self?.errorMessage ?? "")
                    }
                }
                
            }
            
        }else{
            
        }
        dataTask?.resume()
    }
    func updateResult(_ data: Data) {
//        let res = String(decoding: data, as: UTF8.self)
        let res = try? JSONDecoder().decode(ApiResponse<[Track]>.self, from: data)
        if let res = res{
            self.tracks = res.data
        }
    }
    
}
