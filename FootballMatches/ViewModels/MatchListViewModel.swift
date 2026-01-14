import Foundation
import Combine

@MainActor
class MatchListViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    func loadMatches(from: Date, to: Date) async {
        isLoading = true
        errorMessage = nil
        do {
            // Passes the dates to the updated APIClient
            let fetched = try await APIClient.shared.fetchMatches(from: from, to: to)
            
            // Sort matches chronologically before assigning them
            self.matches = fetched.sorted(by: { $0.utcDate < $1.utcDate })
        } catch {
            errorMessage = "Failed to load matches: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
