import Foundation

struct Match: Codable, Identifiable {
    let id: Int
    let utcDate: Date
    let status: String
    let venue: String?
    let homeTeam: Team
    let awayTeam: Team
    let score: Score
    let competition: Competition
    let matchday: Int?
    let stage: String? 
    
    struct Competition: Codable {
        let name: String
        let emblem: String?
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: utcDate)
    }
}
