import UIKit

struct Character: Codable {
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
}

