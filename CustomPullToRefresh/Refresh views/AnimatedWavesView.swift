//
//  WavesAnimated.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 11/11/22.
//

import SwiftUI

struct WaveConfiguration: RefreshViewConfig {
    var backgroundColor: Color
    let waveColor: Color
}

struct AnimatedWavesView: View {
    
    let config: WaveConfiguration
    @Binding var animate: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            
            WaveView(yOffset: animate ? 0.5 : -0.5)
                .fill(config.waveColor)
                .frame(height: 150)
                .shadow(radius: 4)
                .animation(animate ? Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true) : .default, value: animate)
            
            WaveView(yOffset: animate ? -0.5 : 0.5)
                .fill(config.waveColor)
                .opacity(0.8)
                .frame(height: 140)
                .shadow(radius: 4)
                .overlay {
                    // Text("wave")
                    //     .font(.largeTitle)
                    //     .fontWeight(.bold)
                }
                .animation(animate ? Animation.easeInOut(duration: 0.7)
                    .repeatForever(autoreverses: true) : .default, value: animate)
            
        }
        .background(config.backgroundColor)
//        .clipped()
    }
}

struct AnimationWeavesView_Previews: PreviewProvider {
    
    @State static var shouldAnimate = true
    static let config = WaveConfiguration(backgroundColor: .black, waveColor: .blue)
    
    static var previews: some View {
        AnimatedWavesView(config: config, animate: $shouldAnimate)
    }
}
