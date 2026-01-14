import Foundation

struct Team: Codable, Identifiable {
    let id: Int
    let name: String
    let crest: String? // API uses 'crest' for the image URL
}
