//
//  MoviesListControllerViewModel.swift
//  JatAppTest
//
//  Created by Ihor Zaliskyj on 21.11.2022.
//

import Foundation
import UIKit

let moviesMaxCount : Int = 10

class MoviesListControllerViewModel : MoviesListControllerDelegate {
    private var isSearch: Bool = false
    private var movies: [Movie]?
    private var filteredMovies: [Movie]?
    var chars = [String:Int]()
    
    var numberOfRows : Int {
        guard movies != nil else {return 0}
        let rows = isSearch ? filteredMovies?.count : movies?.count
        return rows! < moviesMaxCount ? rows! : moviesMaxCount
    }
    
    
    func movie(for row:Int)->Movie{
        if isSearch{ return filteredMovies![row] }
        return movies![row]
    }
    
    func loadMoviesList(_ completion: @escaping (Error?) -> Void) {
        ApiManager.dataRequest(with: top250MoviesUrl, objectType: MoviesResponse.self) { result in
            DispatchQueue.main.async {
            switch result {
                case .success(let object):
                    self.movies = object.items
                    self.calculateCharRepeats()
                    completion(nil)
                case .failure(let error):
                completion(error)
            }
            }
        }
    }
    
    func filterMovies(_ searchText: String) {
        isSearch = !searchText.isEmpty
        filteredMovies = movies?.filter { (movie: Movie) -> Bool in
            return movie.title.lowercased().contains(searchText.lowercased())
      }
    }
    
    func calculateCharRepeats(){
        for i in 0..<moviesMaxCount{
            let title = self.movies![i].title
            for c in title {
                if chars[String(c)] == nil {
                    chars[String(c)] = 1
                } else {
                    chars[String(c)] = chars[String(c)]! + 1
                }
            }
        }
    }
}
