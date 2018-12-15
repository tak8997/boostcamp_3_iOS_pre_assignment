//
//  OrderType.swift
//  BoxOffice
//
//  Created by Gaon Kim on 12/12/2018.
//  Copyright © 2018 Gaon Kim. All rights reserved.
//

import Foundation

class OrderType {
    static var shared: OrderType = OrderType()
    
    var order: Order? = Order(rawValue: 0)
    var movies: [Movie] = []
}

enum Order: Int {
    case reservationRate = 0
    case curation = 1
    case releaseDate = 2
    
    func getActionName() -> String {
        switch self {
        case .reservationRate:
            return "예매율"
        case .curation:
            return "큐레이션"
        case .releaseDate:
            return "개봉일"
        }
    }
    
    func getTitleName() -> String {
        switch self {
        case .reservationRate:
            return "예매율순"
        case .curation:
            return "큐레이션"
        case .releaseDate:
            return "개봉일순"
        }
    }
}
