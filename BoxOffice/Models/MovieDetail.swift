//
//  MovieDetail.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import Foundation

struct MovieDetail: Codable {
    let reservationRate: Double
    let id: String
    let audience: Int
    let userRating: Double
    let image: String
    let grade: Int
    let actor, date, synopsis, director: String
    let duration: Int
    let title: String
    let reservationGrade: Int
    let genre: String
    
    enum CodingKeys: String, CodingKey {
        case reservationRate = "reservation_rate"
        case id, audience
        case userRating = "user_rating"
        case image, grade, actor, date, synopsis, director, duration, title
        case reservationGrade = "reservation_grade"
        case genre
    }
}
