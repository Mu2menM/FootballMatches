import SwiftUI

struct MatchRowView: View {
    let match: Match
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                // Home Team
                teamVStack(name: match.homeTeam.name, logo: match.homeTeam.crest)
                
                // Score / Time
                VStack(spacing: 4) {
                    if match.status == "TIMED" || match.status == "SCHEDULED" {
                        Text(match.utcDate, style: .time)
                            .font(.headline)
                            .foregroundColor(.blue)
                    } else {
                        Text("\(match.score.fullTime.home ?? 0) - \(match.score.fullTime.away ?? 0)")
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                        
                        if match.status == "IN_PLAY" {
                            Text("LIVE")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                    }
                }
                .frame(width: 100)
                
                // Away Team
                teamVStack(name: match.awayTeam.name, logo: match.awayTeam.crest)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemBackground)))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    @ViewBuilder
    private func teamVStack(name: String, logo: String?) -> some View {
        VStack {
            AsyncImage(url: URL(string: logo ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFit()
                default:
                    Image(systemName: "sportscourt").foregroundColor(.gray)
                }
            }
            .frame(width: 40, height: 40)
            
            Text(name)
                .font(.caption)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}
