//
//  Requests.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

class Requests {
    static let DidReceivedMovieListNotification: Notification.Name = Notification.Name("didReceiveMovieListNotification")
    
    static func requestMovieList(order: Order?, completion: (() -> Void)?) {
        guard let orderType: Int = order?.rawValue else { return }
        let urlString: String = "http://connect-boxoffice.run.goorm.io/movies?order_type=\(orderType)"
        guard let url: URL = URL(string: urlString) else { return }
        
        Network.request(url: url) { data in
            do {
                let movieList: MovieList = try JSONDecoder().decode(MovieList.self, from: data)
                
                NotificationCenter.default.post(name: DidReceivedMovieListNotification, object: nil)
                OrderType.shared.movies = movieList.movies
                
                completion?()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static func requestMovieDetail(id: String, completion: @escaping ((MovieDetail) -> Void)) {
        let urlString: String = "http://connect-boxoffice.run.goorm.io/movie?id=\(id)"
        guard let url: URL = URL(string: urlString) else { return }
        
        Network.request(url: url) { data in
            do {
                let movieDetail: MovieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                completion(movieDetail)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static func requestComments(id: String, completion: @escaping ((CommentList) -> Void)) {
        let urlString: String = "http://connect-boxoffice.run.goorm.io/comments?movie_id=\(id)"
        guard let url: URL = URL(string: urlString) else { return }
        
        Network.request(url: url) { data in
            do {
                let commentList: CommentList = try JSONDecoder().decode(CommentList.self, from: data)
                completion(commentList)
            } catch {
                print(urlString)
                print(error.localizedDescription)
            }
        }
    }
    
    static func requestImage(imageUrl: String, completion: @escaping ((UIImage) -> Void)) {
        guard let url: URL = URL(string: imageUrl) else { return }
        
        Network.fetchImage(url: url) { data in
            if let image: UIImage = UIImage(data: data) {
                completion(image)
            }
        }
    }
}
