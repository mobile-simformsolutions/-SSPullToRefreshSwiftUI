//
//  ContentView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 01/11/22.
//

import SwiftUI

struct ContentView: View {
    
//    let config = RotatingImageConfiguration(backgroundColor: .black, rotatingImage: "spinnerTwo")
    
//    let config = WaveConfiguration(backgroundColor: .red, waveColor: .blue)

//    let config = PulseConfiguration(backgroundColor: .red, pulseColor: .black, circleColor: .blue, shadowColor: .gray)

    let config = LottieConfiguration(backgroundColor: .white, lottieFileName: "PaperPlane")
    
    var body: some View {
        
        CombinedRefreshView(configuration: config) {
            contentView
        } onRefresh: {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            print("refresh complete")
        } refreshInitiated: {
            print("refresh initiated")
        }
    }
    
    private var contentView: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
