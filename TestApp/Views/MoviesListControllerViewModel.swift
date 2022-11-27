//
//  MoviesListControllerViewModel.swift
//  JatAppTest
//
//  Created by Ihor Zaliskyj on 21.11.2022.
//

import Foundation
import UIKit

class MoviesListControllerViewModel : MoviesListControllerDelegate {
    
    private var isSearch: Bool = false
    private var movies: [Movie]?
    private var filteredMovies: [Movie]?
    var chars = [String:Int]()
    let moviesMaxCount : Int = 10
    
    var numberOfRows : Int {
        guard movies != nil else { return 0 }
        if let rows = isSearch ? filteredMovies?.count : movies?.count {
            return rows < moviesMaxCount ? rows : moviesMaxCount
        }
        return 0
    }
    
    
    func movie(for row:Int) -> Movie? {
        return isSearch ? filteredMovies?[row] : movies?[row]
    }
    
    
    func loadMoviesList(_ completion: @escaping (Error?) -> Void) {
        let top250moviesUrl = "https://imdb-api.com/en/API/Top250Movies/k_nnlqtizq"
        ApiManager.shared.loadTop250MoviesRequest(with: top250moviesUrl) { [weak self] result in
            switch result {
            case .success(let object):
                if let items = object.items {
                    self?.movies = items
                    self?.calculateCharRepeats()
                }
            case .error(let error):
                completion(error)
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
            if let title = self.movies?[i].title {
                for c in title {
                    if let count = chars[String(c)]{
                        chars[String(c)] = count + 1
                    } else {
                        chars[String(c)] = 1
                    }
                }
            }
        }
    }
    
}
