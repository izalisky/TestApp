//
//  MoviesResponse.swift
//  JatAppTest
//
//  Created by Ihor Zaliskyj on 21.11.2022.
//

import Foundation

struct MoviesResponse :Decodable {
    var items : [Movie]?
    var errorMessage : String?
}
