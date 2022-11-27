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
        self.title = NSLocalizedString("Top 250 movies", comment: "")
        self.showLoading()
        self.addRefreshControl()
        self.addSearchBar()
        viewModel = MoviesListControllerViewModel()
        self.refresh()
    }
    
    
    func showLoading(){
        guard let view = self.navigationController?.view else { return }
        indicator.center = view.center
        indicator.color = .label
        view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    
    // MARK: - Pull to refresh methods
    
    func addRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    

    @objc func refresh() {
        viewModel?.loadMoviesList({ [weak self] error in
            DispatchQueue.main.async() {
                self?.endRefresh()
                if error != nil {
                    self?.showAlert(title: NSLocalizedString("Error", comment: ""), message: error?.localizedDescription)
                }
            }
        })
    }
    
    
    func endRefresh(){
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
        return viewModel?.numberOfRows ?? 0
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        guard let movieCell = cell as? MoviewPreviewCell else { return cell }
        movieCell.movie = viewModel?.movie(for: indexPath.row)
        return movieCell
    }
    
    
    override func tableView(_ __tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let rows = viewModel?.numberOfRows, rows != 0 else { return }
        if rows > 0 && !animationEnd {
            var frame: CGRect = cell.frame
            let originframe: CGRect = cell.frame
            frame.origin.y = frame.origin.y + UIScreen.main.bounds.size.height
            cell.frame = frame
            
            UIView.animate(withDuration: 1.5,
                           delay: Double(indexPath.row) * 0.1,
                           usingSpringWithDamping: 0.75,
                           initialSpringVelocity: 0.3,
                           options: [],
                           animations: {
                cell.frame = originframe
            }) { finished in
                self.animationEnd = (self.tableView.visibleCells.count - 1) <= indexPath.row
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = viewModel?.movie(for: indexPath.row) {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MoviewDetailsController") as? MoviewDetailsController {
                controller.movie = movie
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    
    @IBAction func openCharterInTitleController(){
        if let chars = viewModel?.chars {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "CharacterInTitleController") as? CharacterInTitleController {
                controller.chars = chars
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
}

extension MoviesListController: UISearchResultsUpdating {
    
    func addSearchBar(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search Movie", comment: "")
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.filterMovies(searchController.searchBar.text ?? "")
        self.tableView.reloadData()
    }
    
}
