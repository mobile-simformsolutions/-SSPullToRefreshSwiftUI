//
//  ContentView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 01/11/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var jokes = Jokes()
    
//    let config = RotatingImageConfiguration(backgroundColor: .black, rotatingImage: "spinnerTwo")
    
//    let config = WaveConfiguration(backgroundColor: .red, waveColor: .blue)

//    let config = PulseConfiguration(backgroundColor: .red, pulseColor: .black, circleColor: .blue, shadowColor: .gray)

    let config = LottieConfiguration(backgroundColor: .white, lottieFileName: "PaperPlane")
    
    var body: some View {
        
        CombinedRefreshView(configuration: config) {
            contentView
        } onRefresh: {
            // try? await Task.sleep(nanoseconds: 3_000_000_000)
            await fetchData()
            print("refresh complete")
        } refreshInitiated: {
            print("refresh initiated")
        }
    }
    
    private var contentView: some View {
        NavigationView {
            VStack {
                List(jokes, id: \.id) { joke in
                    VStack(alignment: .leading) {
                        Text(joke.setup)
                            .font(.headline)
                        Text(joke.punchline)
                            .font(.body )
                    }
                }
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension ContentView {
    
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
