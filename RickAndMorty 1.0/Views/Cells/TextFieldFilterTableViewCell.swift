import UIKit

class TextFieldFilterTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    
    var delegate: TextFieldFilterTableViewCellDelegate?
    
    func setup(placeholder: String, value: String?) {
        textField.delegate = self
        textField.placeholder = placeholder
        
        if let value = value {
            textField.text = value
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        guard let text = textField.text, !text.isEmpty else { return }
        
        delegate?.textFieldFilterCell(self, didChangeValue: text)
    }
}
