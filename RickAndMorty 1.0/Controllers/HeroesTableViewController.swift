import UIKit

class HeroesTableViewController: UITableViewController {
    var searchController = UISearchController()
    
    var currentPage = 1
    var totalPages = 1
    var heroes = [Hero]()
    
    var filters: [String: String]?
    var searchTerm: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
       fetchHeroes()
    }
    
    func updateUI(with heroResponse: HeroResponse, clearExisting: Bool) {
        DispatchQueue.main.async {
            self.totalPages = heroResponse.info.pages
            
            if clearExisting {
                self.heroes = heroResponse.results
            } else {
                self.heroes += heroResponse.results
            }
            
            self.tableView.reloadData()
        }
    }
    
    func fetchHeroes(clearExisting: Bool = true) {
        var queryItems = ["page": "\(currentPage)"]
        
        if let filters = filters {
            filters.forEach { (key, value) in
                queryItems[key] = value
            }
        }
        
        if let searchTerm = searchTerm {
            queryItems["name"] = searchTerm
        }
        
        HeroController.shared.fetchHeroes(queryItems: queryItems) { (result) in
            switch result {
            case .success(let heroResponse):
                self.updateUI(with: heroResponse, clearExisting: clearExisting)
            case .failure(let error):
                self.displayError(error, title: "Failed to Fetch New Heroes")
            }
        }
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "Hero", for: indexPath) as?  HeroTableViewCell
        else { return UITableViewCell() }
        
        let hero = heroes[indexPath.row]
        
        cell.update(with: hero)
        
        HeroController.shared.fetchImage(url: hero.imageURL) { (image) in
            DispatchQueue.main.async {
                if let image = image {
                    cell.heroImageView.image = image
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if currentPage < totalPages && indexPath.row == heroes.count - 1 {
            currentPage += 1
            
            fetchHeroes(clearExisting: false)
        }
    }
    
    @IBSegueAction func showFilters(_ coder: NSCoder) -> FiltersTableViewController? {
        return FiltersTableViewController(coder: coder, filters: filters)
    }
    
    @IBAction func unwindToHeroTableViewController (segue: UIStoryboardSegue) {
        if segue.identifier == "applyFiltersSegue", let filters = filters {
            self.filters = filters
           fetchHeroes()
        }
    }
}

extension HeroesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text, !searchString.isEmpty {
            searchTerm = searchString
            fetchHeroes()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTerm = nil
        fetchHeroes()
    }
}
