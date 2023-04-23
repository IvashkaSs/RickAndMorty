import UIKit

class HeroesTableViewController: UITableViewController {
    var currentPage = 1
    var totalPages = 1
    var heroes = [Hero]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HeroController.shared.fetchHeroes { (result)  in
            switch result {
            case .success(let heroResponse):
                self.updateUI(with: heroResponse)
            case .failure(let error):
                self.displayError(error, title: "Failed to Fetch Hero")
            }
        }
    }
    
    func updateUI(with heroResponse: HeroResponse) {
        DispatchQueue.main.async {
            self.totalPages = heroResponse.info.pages
            self.heroes += heroResponse.results
            self.tableView.reloadData()
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
          
            HeroController.shared.fetchHeroes(queryItems: ["page": "\(currentPage)"]) { (result) in
                switch result {
                case .success(let heroResponse):
                    self.updateUI(with: heroResponse)
                case .failure(let error):
                    self.displayError(error, title: "Failed to Fetch New Heroes")
                }
            }
        }
    }
}
