import UIKit

class Character: Codable {
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var origin: String
    var locationName: String
    var locationURL: URL
    var episode: [URL]
    
    
    enum CodingKeys:String, CodingKey {
        case name
        case status
        case species
        case type
        case gender
        case origin
        case locationName = "location"
        case locationURL
        case episode
    }
}

