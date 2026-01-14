import SwiftUI

struct MatchListView: View {
    @StateObject private var viewModel = MatchListViewModel()
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var searchText = ""
    
    // grouping logic looks
    var groupedMatches: [String: [Match]] {
        let filtered = searchText.isEmpty ? viewModel.matches : viewModel.matches.filter {
            $0.homeTeam.name.localizedCaseInsensitiveContains(searchText) ||
            $0.awayTeam.name.localizedCaseInsensitiveContains(searchText)
        }
        // This line depends on 'competition' being in Match struct!
        return Dictionary(grouping: filtered, by: { $0.competition.name })
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 1. Date Selection Header
                VStack(spacing: 10) {
                    HStack {
                        DatePicker("From", selection: $fromDate, displayedComponents: .date)
                        Divider().frame(height: 20)
                        DatePicker("To",
                                   selection: $toDate,
                                   in: fromDate...(Calendar.current.date(byAdding: .day, value: 10, to: fromDate) ?? fromDate),
                                   displayedComponents: .date)
                    }
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                .background(Color(.secondarySystemBackground))

                // 2. Main Match List
                ZStack {
                    Color(.systemGroupedBackground).ignoresSafeArea()
                    
                    if viewModel.isLoading {
                        ProgressView("Loading Matches...")
                    } else if let error = viewModel.errorMessage {
                        VStack {
                            Text("Warning ").font(.largeTitle)
                            Text(error).multilineTextAlignment(.center)
                            Button("Retry") { loadData() }
                        }.padding()
                    } else if groupedMatches.isEmpty {
                        Text("No matches found for these dates.")
                            .foregroundColor(.secondary)
                    } else {
                        List {
                            // Sorted keys to keep leagues in alphabetical order
                            ForEach(groupedMatches.keys.sorted(), id: \.self) { leagueName in
                                Section(header: Text(leagueName)
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .textCase(nil)) {
                                    
                                    ForEach(groupedMatches[leagueName] ?? []) { match in
                                        NavigationLink(destination: MatchDetailView(match: match)) {
                                            MatchRowView(match: match)
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                    }
                }
            }
            .navigationTitle("Football Schedule")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: RemindersView()) {
                        Image(systemName: "bell.badge.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search for a team")
            // Automatically reload data when dates change
            .onChange(of: fromDate) { _ in loadData() }
            .onChange(of: toDate) { _ in loadData() }
            .task { loadData() }
        }
    }
    
    private func loadData() {
        Task {
            await viewModel.loadMatches(from: fromDate, to: toDate)
        }
    }
}
