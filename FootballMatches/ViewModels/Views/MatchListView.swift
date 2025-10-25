
import SwiftUI

struct MatchListView: View {
    @StateObject private var viewModel = MatchListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Matches...")
                } else if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                } else {
                    List(viewModel.matches) { match in
                        MatchRowView(match: match)
                    }
                }
            }
            .navigationTitle("Football Matches")
            .task {
                await viewModel.loadMatches()
            }
        }
    }
}

#Preview {
    MatchListView()
}
