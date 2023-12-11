//
//  ImageList.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 07/07/23.
//

import SwiftUI

struct ImageList: View {
    
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
    }
    
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

struct ImageList_Previews: PreviewProvider {
    static var previews: some View {
        ImageList()
    }
}

// MARK: - Joke
struct Joke: Codable {
    let id: Int
    let type, setup, punchline: String
}

typealias Jokes = [Joke]
