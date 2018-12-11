//
//  MovieList.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import UIKit

struct MovieList: Codable {
    let movies: [Movie]
    let orderType: Int
    
    enum CodingKeys: String, CodingKey {
        case movies
        case orderType = "order_type"
    }
}

struct Movie: Codable {
    let reservationRate: Double
    let id: String
    let userRating: Double
    let grade: Int
    let date, title: String
    let reservationGrade: Int
    let thumb: String
    
    var informationForTable: String {
        return "평점 : \(self.userRating) 예매순위 : \(self.reservationGrade) 예매율 : \(self.reservationRate)"
    }
    var informationForCollection: String {
        return "\(self.reservationGrade)위(\(self.userRating)) / \(self.reservationRate)%"
    }
    var releaseDate: String {
        return "개봉일: \(date)"
    }
    var gradeImage: String {
        var age: String {
            return (grade == 0 ? "allages" : String(grade))
        }
        let imageName: String = "ic_" + age
        return imageName
    }
    
    enum CodingKeys: String, CodingKey {
        case reservationRate = "reservation_rate"
        case id
        case userRating = "user_rating"
        case grade, date, title
        case reservationGrade = "reservation_grade"
        case thumb
    }
}
