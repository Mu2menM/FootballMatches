import Foundation

struct Team: Codable, Identifiable {
    let id: Int
    let name: String
    let logo: String?
}
