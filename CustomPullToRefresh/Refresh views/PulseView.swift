//
//  PulseView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 14/11/22.
//

import SwiftUI

struct PulseConfiguration: RefreshViewConfig {
    var backgroundColor: Color
    let pulseColor: Color
    let circleColor: Color
    let shadowColor: Color
}

struct PulseView: View {
    
    @State private var height: CGFloat = 150
    @State private var pulse1 = false
    @State private var pulse2 = false
    @State private var pulse3 = false
    
    @Binding var shouldAnimate: Bool
    
    let config: PulseConfiguration
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                Circle()
                    .stroke(config.pulseColor.opacity(0.5))
                    .frame(height: height)
                    .scaleEffect(pulse1 ? 3 : 0)
                    .opacity(pulse1 ? 0 : 1)
                
                Circle()
                    .stroke(config.pulseColor.opacity(0.5))
                    .frame(height: height)
                    .scaleEffect(pulse2 ? 3 : 0)
                    .opacity(pulse2 ? 0 : 1)
                
                Circle()
                    .stroke(config.pulseColor.opacity(0.5))
                    .frame(height: height)
                    .scaleEffect(pulse3 ? 3 : 0)
                    .opacity(pulse3 ? 0 : 1)
                
                Circle()
                    .fill(config.circleColor)
                    .frame(height: height/2)
                    .shadow(color: config.shadowColor, radius: 5, x: 5, y: 5)
                
            }
            
            // Button {
            //     shouldAnimate = false
            //     shouldAnimate.toggle()
            // } label: {
            //     Text("Start/ Stop")
            // }
            
        }
        .onChange(of: shouldAnimate, perform: { newValue in
            animate()
        })
        .frame(maxWidth: .infinity)
        .background(config.backgroundColor)
        .clipped()
    }
    
    func animate() {
        
        withAnimation(shouldAnimate ? Animation.linear(duration: 2).repeatForever(autoreverses: false) : .default) {
            pulse1.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(shouldAnimate ? Animation.linear(duration: 2).repeatForever(autoreverses: false) : .default) {
                pulse2.toggle()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(shouldAnimate ? Animation.linear(duration: 2).repeatForever(autoreverses: false) : .default) {
                pulse3.toggle()
            }
        }
    }
}

struct PulseView_Previews: PreviewProvider {
    
    @State static var animate = false
    static let config = PulseConfiguration(backgroundColor: .black, pulseColor: .blue, circleColor: .blue, shadowColor: .orange)
    
    static var previews: some View {
        PulseView(shouldAnimate: $animate, config: config)
    }
}
