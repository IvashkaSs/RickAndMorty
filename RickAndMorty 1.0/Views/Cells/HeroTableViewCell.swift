import UIKit

class HeroTableViewCell: UITableViewCell {

   
    @IBOutlet var heroImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
	@IBOutlet var statusLabel: UILabel!
    @IBOutlet var statusView: UIView!
    
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func update(with hero: Hero) {
        nameLabel.text = hero.name
        statusLabel.text = hero.status
        statusView.layer.cornerRadius = 4.0
    }
}
