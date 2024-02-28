//
//  APICallTestView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 27/02/24.
//

import SwiftUI

struct APICallTestView: View {
    
    @State private var jokes = Jokes()
    
    var body: some View {
        List(jokes, id: \.id) { joke in
            VStack(alignment: .leading) {
                Text(joke.setup)
                    .font(.headline)
                Text(joke.punchline)
                    .font(.body )
            }
        }
        .task {
            await fetchData()
        }
        .overlay {
            if #available(iOS 17.0, *) {
                if jokes.isEmpty {
                    /// In case there aren't any search results, we can
                    /// show the new content unavailable view.
                    ContentUnavailableView.search
                } else {
                    // Fallback on earlier versions
//                            Image(systemName: "globe")
//                                .imageScale(.large)
//                                .foregroundColor(.accentColor)
//                            Text("Hello, world!")
                }
            }
        }
    }
}

#Preview {
    APICallTestView()
}

extension APICallTestView {
    
    func fetchData() async {
        guard let url = URL(string: "https://official-joke-api.appspot.com/random_ten") else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Jokes.self, from: data) {
                jokes = decodedResponse
            }
        } catch {
            print("invalid data: \(error.localizedDescription)")
        }
    }
}
