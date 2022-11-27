//
//  MoviesListControllerDelegate.swift
//  JatAppTest
//
//  Created by Ihor Zaliskyj on 21.11.2022.
//

import Foundation


protocol MoviesListControllerDelegate {
    
    var numberOfRows : Int { get }
    var chars : [String:Int] { get }
    func loadMoviesList(_ completion: @escaping (Error?) -> Void)
    func movie(for row:Int) -> Movie?
    func filterMovies(_ searchText: String)
    
}
