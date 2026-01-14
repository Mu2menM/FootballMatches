import SwiftUI
import UserNotifications

struct MatchDetailView: View {
    let match: Match
    
    // Check if the game is eligible for a notification
    var isFinishedOrLive: Bool {
        return match.status == "FINISHED" || match.status == "IN_PLAY" || match.status == "PAUSED"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header: Competition Info
                HStack {
                    AsyncImage(url: URL(string: match.competition.emblem ?? "")) { img in
                        img.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 30, height: 30)
                    
                    Text(match.competition.name)
                        .font(.headline)
                }
                .padding(.top)

                // Scoreboard
                HStack {
                    detailTeamView(name: match.homeTeam.name, logo: match.homeTeam.crest)
                    VStack {
                        Text("\(match.score.fullTime.home ?? 0) : \(match.score.fullTime.away ?? 0)")
                            .font(.system(size: 40, weight: .black))
                        Text(match.status.replacingOccurrences(of: "_", with: " "))
                            .font(.subheadline).foregroundColor(.secondary)
                    }
                    detailTeamView(name: match.awayTeam.name, logo: match.awayTeam.crest)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(20)
                
                // Detailed Match Info
                VStack(alignment: .leading, spacing: 15) {
                    infoRow(icon: "calendar", label: "Date", value: match.formattedDate)
                    if let venue = match.venue {
                        infoRow(icon: "mappin.and.ellipse", label: "Stadium", value: venue)
                    }
                    if let matchday = match.matchday {
                        infoRow(icon: "sportscourt", label: "Matchday", value: "\(matchday)")
                    }
                    if let stage = match.stage {
                        infoRow(icon: "trophy", label: "Stage", value: stage.replacingOccurrences(of: "_", with: " "))
                    }
                }
                .padding()
                
                // Notification Button: Only enabled for future matches
                Button(action: scheduleNotification) {
                    Label(isFinishedOrLive ? "Match Started/Ended" : "Remind Me When It Starts",
                          systemImage: isFinishedOrLive ? "bell.slash.fill" : "bell.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isFinishedOrLive ? Color.gray : Color.blue)
                        .cornerRadius(12)
                }
                .disabled(isFinishedOrLive) // Disable the button for finished/live games
                .padding(.horizontal)
                
                if isFinishedOrLive {
                    Text("Notifications are only available for upcoming matches.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Match Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Helper Views (detailTeamView and infoRow remain the same as before)
    func detailTeamView(name: String, logo: String?) -> some View {
        VStack {
            AsyncImage(url: URL(string: logo ?? "")) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Image(systemName: "sportscourt").foregroundColor(.gray)
            }
            .frame(width: 80, height: 80)
            
            Text(name).font(.headline).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    func infoRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Image(systemName: icon).foregroundColor(.blue).frame(width: 30)
            Text(label).bold()
            Spacer()
            Text(value).foregroundColor(.secondary)
        }
    }
    
    func scheduleNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Match Starting!"
                content.body = "\(match.homeTeam.name) vs \(match.awayTeam.name) is about to kick off."
                content.sound = .default
                
                let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: match.utcDate)
                //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                
                // --- Only for testing TESTING ---
                // Triggers in 5 seconds instead of the actual match date
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                // ---------------------
                
                let request = UNNotificationRequest(identifier: "\(match.id)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}
