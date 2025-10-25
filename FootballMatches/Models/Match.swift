
import Foundation

struct Match: Codable, Identifiable {
    let id: Int
    let homeTeam: Team
    let awayTeam: Team
    let date: Date
    let score: Score?
    let status: String
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
