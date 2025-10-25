import Foundation
import Combine   // 👈 add this line

@MainActor
class MatchListViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    func loadMatches() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await APIClient.shared.fetchMatches()
            matches = fetched
        } catch {
            errorMessage = "Failed to load matches: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
