
import SwiftUI

struct MatchRowView: View {
    let match: Match
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(match.homeTeam.name) vs \(match.awayTeam.name)")
                    .font(.headline)
                Text(match.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            if let score = match.score {
                Text("\(score.home ?? 0) : \(score.away ?? 0)")
                    .font(.headline)
            } else {
                Text(match.status)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
    }
}
