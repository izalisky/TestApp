//
//  MoviesListController.swift
//  JatAppTest
//
//  Created by Ihor Zaliskyj on 21.11.2022.
//

import UIKit

class MoviesListController: UITableViewController {
    var viewModel : MoviesListControllerDelegate?
    let indicator = UIActivityIndicatorView(style: .medium)
    var animationEnd = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top 250 movies"
        self.showLoading()
        self.addRefreshControl()
        self.addSearchBar()
        viewModel = MoviesListControllerViewModel()
        self.refresh()
    }
    
    func showLoading(){
        indicator.center = (self.navigationController?.view.center)!
        indicator.color = .black
        self.navigationController?.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    // MARK: - Pull to refresh methods
    
    func addRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }

    @objc func refresh() {
        viewModel?.loadMoviesList({error in
            self.perform(#selector(self.endRefresh), with: nil, afterDelay: 2.0)
            if error != nil {
                self.showAlert(title: "Error", message: error?.localizedDescription)
                return
            }
        })
    }
    
    @objc func endRefresh(){
        if indicator.superview != nil {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MoviewPreviewCell
        cell?.movie = viewModel?.movie(for: indexPath.row)
        return cell!
    }
    
    override func tableView(_ __tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel!.numberOfRows > 0 && !animationEnd {
            var frame: CGRect = cell.frame
            let originframe: CGRect = cell.frame
            frame.origin.y = frame.origin.y + UIScreen.main.bounds.size.height
            cell.frame = frame
            
            UIView.animate(withDuration: 1.5, delay: Double(indexPath.row) * 0.1, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.3, options: [], animations: {
                cell.frame = originframe
            }) { finished in
                self.animationEnd = (self.tableView.visibleCells.count - 1) <= indexPath.row
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let cell = sender as? MoviewPreviewCell
            let controller = segue.destination as? MoviewDetailsController
            controller?.movie = cell?.movie
        }
        if segue.identifier == "info" {
            let controller = segue.destination as? CharacterInTitleController
            controller?.chars = viewModel!.chars
        }
    }
    
}

extension MoviesListController: UISearchResultsUpdating {
    
    // MARK: - search methods
    
    func addSearchBar(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movie"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.filterMovies(searchController.searchBar.text ?? "")
        self.tableView.reloadData()
    }
}
