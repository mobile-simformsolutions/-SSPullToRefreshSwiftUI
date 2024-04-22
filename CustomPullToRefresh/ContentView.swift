//
//  ContentView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 01/11/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var jokes = Jokes()
    @State private var items = (1...110).map { "Item \($0)" }
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var isRefreshing = false
    
    @State private var randomImages = RandomImage.samples()
    let rows = Array(repeating: GridItem(.fixed(120), spacing: 0), count: 2)
    
    var body: some View {
        
        // Double helix
//         CombinedRefreshView(refreshViewType: .lottieSwiftUI(backgroundColor: .clear, lottieFileName: "PaperPlane"), dynamicIslandType: .doubleHelix, isShowing: $isShowing) {
             
             // Paper plane
//        CombinedRefreshView(refreshViewType: .lottieSwiftUI(backgroundColor: .clear, lottieFileName: "PaperPlane"), isShowing: $isShowing) {
             
             // loading text
//         CombinedRefreshView(refreshViewType: .lottieSwiftUI(backgroundColor: .clear, lottieFileName: "PaperPlane"), dynamicIslandType: .textAnimation(title: "Loading ..."), isShowing: $isShowing) {
           
//        
//        CombinedRefreshView(refreshViewType: .lottieSwiftUI(backgroundColor: .clear, lottieFileName: "PaperPlane"), dynamicIslandType: .pulseOutline(color: .white, speed: 0.5), isShowing: $isShowing) {
        

        // pulse outline - predefined speed enum, custom speed
        
        CombinedRefreshView(refreshViewType: .lottieSwiftUI(backgroundColor: .clear, lottieFileName: "PaperPlane"), dynamicIslandType: .pulseOutline(color: .white, speed: .medium), isRefreshing: $isRefreshing) {
            staticContentView
//            contentView2
//             contentView3
        } refreshInitiated: {
            print("refresh initiated")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                items.shuffle()
                isRefreshing = false
                print("refresh completed")
            })
//            Task {
//                await fetchData()
//            }
//            shuffleImages()
        }
    }
    
    private func shuffleImages() {
        DispatchQueue.global(qos: .userInitiated).async {
            let shuffled = RandomImage.samples().shuffled()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                randomImages = shuffled
                isRefreshing = false
            })
        }
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
    
    private var contentView2: some View {
        LazyVStack {
            if jokes.isEmpty {
                VStack {
                    Image(systemName: "arrow.clockwise")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Pull down to refresh the view")
                }
                .frame(height: UIScreen.main.bounds.height / 2)
            } else {
                ForEach(jokes, id: \.id) { joke in
                    VStack(spacing: 8) {
                        Text(joke.setup)
                            .multilineTextAlignment(.leading)
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text(joke.punchline)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
            }
        }
    }
    
    private var contentView3: some View {
        ScrollView {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(randomImages) { image in
                        CardView(randomImage: image)
                    }
                }
                .padding()
            }
            .frame(height: 150)
            
//            Section {
//                ScrollView(.horizontal) {
//                    
//                    LazyHGrid(rows: rows, spacing: 0, content: {
//                        ForEach(randomImages) { image in
//                            TileView(randomImage: image, size: 120, cornerRadius: 0)
//                        }
//                    })
//                }
//            } header: {
//                Text("Second section")
//                    .modifier(SectionHeaderStyling())
//                    .padding(.leading)
//            }
            
            LazyVStack(alignment: .leading, spacing: 10, pinnedViews: .sectionHeaders, content: {
                Section {
                    ForEach(randomImages) { image in
                        RowView(randomImage: image)
                    }
                } header: {
                    Text("Third section")
                        .modifier(SectionHeaderStyling())
                }
            })
            .padding()
        }
    }
    
    func stopRefresh() {
        isRefreshing = false
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
                stopRefresh()
                
                // for (index, value) in jokes.enumerated() {
                //     print("\(index): \(value.setup) -> \(value.punchline)")
                // }
            }
        } catch {
            print("invalid data: \(error.localizedDescription)")
        }
    }
}

enum RefreshViewType {
    case rotatingImage(backgroundColor: Color, imageName: String)
    case wave(backgroundColor: Color, waveColor: Color)
    case pulse(backgroundColor: Color, pulseColor: Color, circleColor: Color, shadowColor: Color)
    case lottieUIKit(backgroundColor: Color, lottieFileName: String)
    case lottieSwiftUI(backgroundColor: Color, lottieFileName: String)
}

enum DynamicIslandType {
    case doubleHelix(color: Color)
    case textAnimation(title: String)
    case pulseOutline(color: Color, speed: PulsingSpeed)
}

enum PulsingSpeed {
    case low
    case medium
    case high
    case custom(Double)
    
    var value: Double {
        switch self {
        case .low: return 0.8
        case .medium: return 0.5
        case .high: return 0.2
        case .custom(let value): return value
        }
    }
}
