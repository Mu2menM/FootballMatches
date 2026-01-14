import Foundation

struct Score: Codable {
    let fullTime: TimeResult
    
    struct TimeResult: Codable {
        let home: Int?
        let away: Int?
    }
}
