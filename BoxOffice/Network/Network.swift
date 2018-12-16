//
//  Network.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class Network {
    static func request(url: URL, handler: @escaping ((Data?, Error?) -> Void)) {
        turnOnNetworkIndicator()
        let session: URLSession = URLSession(configuration: .default)
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
        guard let data: Data = try? Data(contentsOf: url) else { return }
        handler(data)
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
