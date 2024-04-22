//
//  RotatingImage.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 09/11/22.
//

import SwiftUI

struct RotatingImageConfiguration: RefreshViewConfig {
    var backgroundColor: Color
    let rotatingImage: String
}

struct RotatingImage: View {
    
    @State private var isAnimating = false
    @State private var showProgress = false
    
    @State private var degree: Double = 0

    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    let config: RotatingImageConfiguration
    
    var body: some View {
        ZStack {
            
            config.backgroundColor
                .ignoresSafeArea()
            
            Button(action: { self.showProgress.toggle() }, label: {
                if showProgress {
                    Image(config.rotatingImage)
                        .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                        .animation(foreverAnimation, value: isAnimating)
                        .onAppear { self.isAnimating = true }
                        .onDisappear { self.isAnimating = false }
                } else {
                    Image(config.rotatingImage)
                }
            })
            .onAppear { self.showProgress = true }
        }
        .clipped()
    }
}

struct RotatingImage_Previews: PreviewProvider {
    static let config = RotatingImageConfiguration(backgroundColor: .black, rotatingImage: "spinnerTwo")
    static var previews: some View {
        RotatingImage(config: config)
    }
}
