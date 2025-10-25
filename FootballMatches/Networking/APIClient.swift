import Foundation

class APIClient {
    static let shared = APIClient()
    private init() {}
    
    func fetchMatches() async throws -> [Match] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let team1 = Team(id: 1, name: "Arsenal", logo: nil)
        let team2 = Team(id: 2, name: "Manchester United", logo: nil)
        let score = Score(home: 2, away: 1)
        
        let match = Match(
            id: 1001,
            homeTeam: team1,
            awayTeam: team2,
            date: Date(),
            score: score,
            status: "Finished"
        )
        
        return [match]
    }
}

