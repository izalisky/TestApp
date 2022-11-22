//
//  Movie.swift
//  JatAppTest
//
//  Created by Ihor Zaliskyj on 21.11.2022.
//

import Foundation
import UIKit

struct Movie : Codable, Equatable {
    var id : String
    var rank : String
    var title : String
    var fullTitle : String
    var year : String
    var image : String
    var crew : String
    var imDbRating : String
    var imDbRatingCount : String
}


