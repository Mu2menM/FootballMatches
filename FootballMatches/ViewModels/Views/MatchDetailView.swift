
import SwiftUI

struct MatchDetailView: View {
    let match: Match
    
    var body: some View {
        VStack(spacing: 16) {
            Text("\(match.homeTeam.name) vs \(match.awayTeam.name)")
                .font(.title)
                .padding()
            if let score = match.score {
                Text("Score: \(score.home ?? 0) - \(score.away ?? 0)")
                    .font(.headline)
            }
            Text("Status: \(match.status)")
            Text("Date: \(match.formattedDate)")
        }
        .navigationTitle("Match Details")
        .padding()
    }
}

#Preview {
    MatchDetailView(match: Match(
        id: 1,
        homeTeam: Team(id: 1, name: "Arsenal", logo: nil),
        awayTeam: Team(id: 2, name: "Man United", logo: nil),
        date: Date(),
        score: Score(home: 3, away: 2),
        status: "Finished"
    ))
}
