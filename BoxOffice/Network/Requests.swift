//
//  Requests.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

// completion을 DispatchQueue.main 안에 넣어 보냄
// 받는 측에서 데이터 설정 시 main thread로 thread를 지정하지 않아도 됨
class Requests {
    static let DidReceivedMovieListNotification: Notification.Name = Notification.Name("didReceiveMovieListNotification")

    private static let baseUrl: String = "http://connect-boxoffice.run.goorm.io/"

    // Movie List 요청
    // Movie List는 Movie Table과 Movie Collection 두 곳에서 동일하게 사용하므로 Notification Center 활용
    // completion(MovieList?, Error?) -> Void 리턴
    static func requestMovieList(order: Order?, completion: @escaping ((MovieList?, Error?) -> Void)) {
        guard let orderType: Int = order?.rawValue else { return }
        let urlString: String = baseUrl + "movies?order_type=\(orderType)"
        guard let url: URL = URL(string: urlString) else { return }

        Network.request(url: url) { data, error in
            do {
                if let data: Data = data {
                    let movieList: MovieList = try JSONDecoder().decode(MovieList.self, from: data)
                    NotificationCenter.default.post(name: DidReceivedMovieListNotification, object: nil)
                    OrderType.shared.movies = movieList.movies
                    
                    DispatchQueue.main.async {
                        completion(movieList, error)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                print(error.localizedDescription)
            }
        }
    }

    // Movie Detail 요청
    // completion(MovieDetail?, Error?) -> Void 리턴
    static func requestMovieDetail(id: String, completion: @escaping ((MovieDetail?, Error?) -> Void)) {
        let urlString: String = baseUrl + "movie?id=\(id)"
        guard let url: URL = URL(string: urlString) else { return }

        Network.request(url: url) { data, error in
            do {
                if let data: Data = data {
                    let movieDetail: MovieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                    DispatchQueue.main.async {
                        completion(movieDetail, error)
                    }
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }

    // Comment List 요청
    // completion(CommentList?, Error?) -> Void 리턴
    static func requestComments(id: String, completion: @escaping ((CommentList?, Error?) -> Void)) {
        let urlString: String = baseUrl + "comments?movie_id=\(id)"
        guard let url: URL = URL(string: urlString) else { return }

        Network.request(url: url) { data, error in
            do {
                if let data = data {
                    let commentList: CommentList = try JSONDecoder().decode(CommentList.self, from: data)
                    DispatchQueue.main.async {
                        completion(commentList, error)
                    }
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }

    // 이미지 요청
    // 성공 시 이미지 리턴
    static func requestImage(imageUrl: String, completion: @escaping ((UIImage) -> Void)) {
        guard let url: URL = URL(string: imageUrl) else { return }

        Network.fetchImage(url: url) { data in
            if let image: UIImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}
