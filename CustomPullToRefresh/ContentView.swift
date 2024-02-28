//
//  ContentView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 01/11/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var jokes = Jokes()
    let items = (1...110).map { "Item \($0)" }
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    //    let config = RotatingImageConfiguration(backgroundColor: .black, rotatingImage: "spinnerTwo")
        
    //    let config = WaveConfiguration(backgroundColor: .red, waveColor: .blue)
    
    //    let config = PulseConfiguration(backgroundColor: .red, pulseColor: .black, circleColor: .blue, shadowColor: .gray)
    
    let config = LottieConfiguration(backgroundColor: .white, lottieFileName: "PaperPlane")
    
    var body: some View {
        
        CombinedRefreshView(configuration: config) {
            staticContentView
//            contentView
        } onRefresh: {
             try? await Task.sleep(nanoseconds: 10_000_000_000)
            // print("refresh complete")
//            await fetchData()
        } refreshInitiated: {
            print("refresh initiated")
        }
//        .background(.gray)
    }
    
    private var staticContentView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 20, height: 100)
                        .background(Color.secondary)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        // .background(.yellow)
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
                .overlay {
                    if jokes.isEmpty {
                        VStack {
                            Image(systemName: "arrow.clockwise")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                            Text("Pull down to refresh the view")
                        }
                    }
                }
            }
        }
        .background(.yellow)
    }
    
//    private var contentView: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hello, world!")
//        }
//        .frame(height: 200)
//    }
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
