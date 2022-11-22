//
//  MoviesResponse.swift
//  JatAppTest
//
//  Created by Ihor Zaliskyj on 21.11.2022.
//

import Foundation

struct MoviesResponse :Codable {
    var items : [Movie]?
    var errorMessage : String?
}
