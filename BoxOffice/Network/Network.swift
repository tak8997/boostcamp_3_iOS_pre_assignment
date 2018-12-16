//
//  Network.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class Network {
    private static var cache: URLCache = URLCache.shared
    private static var session: URLSession = URLSession(configuration: .default)
    
    static func request(url: URL, handler: @escaping ((Data?, Error?) -> Void)) {
        turnOnNetworkIndicator()
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data, response, error) in
            turnOffNetworkIndicator()
            
            if let error = error {
                print(error.localizedDescription)
                handler(nil, error)
                return
            }
            
            guard let data: Data = data else { return }
            handler(data, nil)
        }
        dataTask.resume()
    }
    
    static func fetchImage(url: URL, handler: @escaping ((Data) -> Void)) {
        let request: URLRequest = URLRequest(url: url)
        if let cachedResponse: CachedURLResponse = cache.cachedResponse(for: request) {
            handler(cachedResponse.data)
        } else {
            let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let data = data, let response = response {
                    self.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                    
                    handler(data)
                }
            }
            dataTask.resume()
        }
    }
}

extension Network {
    private static func turnOnNetworkIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    private static func turnOffNetworkIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
