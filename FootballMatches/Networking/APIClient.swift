import Foundation

class APIClient {
    static let shared = APIClient()
    private init() {}
    
    private let apiKey = "e40ef76084c1419fba841cde1075ae4b"
    private let baseURL = "https://api.football-data.org/v4/matches"

    func fetchMatches(from: Date, to: Date) async throws -> [Match] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let fromStr = formatter.string(from: from)
        let toStr = formatter.string(from: to)
        
        let urlString: String
        if fromStr == toStr {
            urlString = "\(baseURL)?date=\(fromStr)"
        } else {
            urlString = "\(baseURL)?dateFrom=\(fromStr)&dateTo=\(toStr)"
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Auth-Token")
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 403 {
                throw NSError(domain: "FootballAPI", code: 403, userInfo: [NSLocalizedDescriptionKey: "Date range too wide. Please select a range of 10 days or less."])
            }
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            let formatter = ISO8601DateFormatter()
            if let date = formatter.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format"
            )
        }
        
        // Print the json response beautified
        if let jsonString = String(data: data, encoding: .utf8),
               let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("=== RAW JSON RESPONSE ===")
            print(prettyString)
            print("=========================")
        }
        let decodedResponse = try decoder.decode(MatchResponse.self, from: data)
        return decodedResponse.matches
        
        
            
    }
}

struct MatchResponse: Codable {
    let matches: [Match]
}
