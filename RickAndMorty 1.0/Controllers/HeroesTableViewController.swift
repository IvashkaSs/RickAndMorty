import UIKit

class HeroesTableViewController: UITableViewController {
    
    var heroResponse: HeroResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        HeroController.shared.fetchCharacters { (result)  in
            switch result {
            case .success(let heroResponse):
                self.updateUI(with: heroResponse)
            case .failure(let error):
                return
            }
        }
    }
    
    
    func updateUI(with heroResponse: HeroResponse) {
        DispatchQueue.main.async {
            self.heroResponse = heroResponse
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroResponse?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "Hero", for: indexPath) as?  HeroTableViewCell,
            let hero = heroResponse?.results[indexPath.row]
        else { return UITableViewCell() }
        
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
}
