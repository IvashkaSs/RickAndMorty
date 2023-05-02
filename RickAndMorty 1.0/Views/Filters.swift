import Foundation

enum Status: String, CaseIterable {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
}

enum Gender: String, CaseIterable {
    case female = "female"
    case male = "male"
    case genderless = "genderless"
    case unknown = "unknown"
}
