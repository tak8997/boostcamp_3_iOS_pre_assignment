//
//  Network.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class Network {
    // MARK: - Properties
    private static var cache: URLCache = URLCache.shared
    private static var session: URLSession = URLSession(configuration: .default)

    // MARK: - Methods
    // url을 이용해 request
    // 성공: 데이터 리턴, 실패: 에러 리턴
    static func request(url: URL, handler: @escaping ((Data?, Error?) -> Void)) {
        turnOnNetworkIndicator()
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                handler(nil, error)
                return
            }

            guard let data: Data = data else { return }
            handler(data, nil)
            
            DispatchQueue.main.async {
                turnOffNetworkIndicator()
            }
        }
        dataTask.resume()
    }

    // URLCache를 이용해 이미지 캐싱
    // 이미지 주소를 request, 성공 시 이미지 데이터 리턴
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

// MARK: - Private Extension
private extension Network {
    static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)

    // turn on: network indicator + activity indicator
    static func turnOnNetworkIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // 현재 활성화 된 화면 중앙에 activity indicator 배치
        if let window = UIApplication.shared.keyWindow {
            activityIndicator.center = window.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            window.addSubview(activityIndicator)
        }
    }

    // turn off: network indicator + activity indicator
    static func turnOffNetworkIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
    }
}
