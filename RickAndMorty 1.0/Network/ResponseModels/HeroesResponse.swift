import Foundation

struct HeroResponse: Codable {
    let info: HeroResponseInfo
    let results: [Hero]
}

struct HeroResponseInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}


