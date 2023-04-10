import UIKit

class HeroTableViewCell: UITableViewCell {

	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var statusLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
