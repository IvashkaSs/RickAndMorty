import UIKit

struct Location: Codable {
    var name: String
    var type: String
    var dimension: String
    var  residents: [Hero]
    var  location: [URL]

}
