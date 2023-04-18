import UIKit

struct Hero: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: ObjectResponse
    let location: ObjectResponse
    let imageURL: URL
    let episodes: [URL]
    let heroURL: URL
    let created: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case origin
        case location
        case imageURL = "image"
        case episodes = "episode"
        case heroURL = "url"
        case created
    }
}



