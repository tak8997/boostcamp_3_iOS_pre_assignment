//
//  Comments.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import Foundation


struct Comments: Codable {
    let movieID: String
    let comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case movieID = "movie_id"
        case comments
    }
}

struct Comment: Codable {
    let rating: Int
    let writer, contents: String
    let movieID: String
    let timestamp: Double
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case rating, writer, contents
        case movieID = "movie_id"
        case timestamp, id
    }
}
