import UIKit

class FiltersTableViewController: UITableViewController {
    
    var species: String?
    var type: String?
    var status: Status?
    var gender: Gender?
    
    init?(coder: NSCoder, filters: [String: String]?) {
        super.init(coder: coder)
        
        guard let filters = filters else { return }
        
        for (key, value) in filters {
            switch key {
            case "species":
                self.species = value
            case "type":
                self.type = value
            case "status":
                self.status = Status(rawValue: value)
            case "gender":
                self.gender = Gender(rawValue: value)
            default:
                return
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1: return 1
        case 2: return Status.allCases.count
        case 3: return Gender.allCases.count
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldFilterTableViewCell
            
            cell.setup(placeholder: "Enter species name...", value: species)
            cell.delegate = self
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldFilterTableViewCell
            
            cell.setup(placeholder: "Enter type...", value: type)
            cell.delegate = self
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            let status = Status.allCases[indexPath.row]
            
            var content = cell.defaultContentConfiguration()
            content.text = status.rawValue.capitalized
            cell.contentConfiguration = content
            
            if self.status == status {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            let gender = Gender.allCases[indexPath.row]
            
            var content = cell.defaultContentConfiguration()
            content.text = gender.rawValue.capitalized
            cell.contentConfiguration = content
            
            if self.gender == gender {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            let status = Status.allCases[indexPath.row]
            self.status = status
            
            tableView.reloadData()
        } else if indexPath.section == 3 {
            let gender = Gender.allCases[indexPath.row]
            self.gender = gender
            
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Species"
        case 1: return "Type"
        case 2: return "Status"
        case 3: return "Gender"
        default: return ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "applyFiltersSegue" ,let heroesTableViewController = segue.destination as? HeroesTableViewController {
            var filters = [String: String]()
            
            if let species = species {
                filters["species"] = species
            }
            if let type = type {
                filters["type"] = type
            }
            
            if let gender = gender {
                filters["gender"] = gender.rawValue
            }
            
            if let status = status {
                filters["status"] = status.rawValue
            }
            
            heroesTableViewController.filters = filters
        }
    }
}

extension FiltersTableViewController: TextFieldFilterTableViewCellDelegate {
    func textFieldFilterCell(_ cell: TextFieldFilterTableViewCell, didChangeValue value: String) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        switch indexPath.section {
        case 0:
            species = value
        case 1:
            type = value
        default: return
        }
    }
}
