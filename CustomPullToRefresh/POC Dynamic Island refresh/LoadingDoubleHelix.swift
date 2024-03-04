//
//  LoadingDoubleHelix.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 04/03/24.
//

import SwiftUI

struct LoadingDoubleHelix: View {
    @State var isAnimating: Bool = false
    let timing: Double
    
    let maxCounter: Int = 20
    
    let frame: CGSize
    let primaryColor: Color
    // let aspectRatio: CGFloat = 3/10 // W100 H30
    let aspectRatio: CGFloat = 1/5 // W100 H30
    
    init(color: Color = .black, width: CGFloat = 350, speed: Double = 0.5) {
        timing = speed * 2
        frame = CGSize(width: width, height: width * CGFloat(aspectRatio))
        primaryColor = color
    }

    var body: some View {
        ZStack {
            
            HStack(spacing: frame.width / 40) {
                ForEach(0..<maxCounter) { index in
                    
                    Circle()
                        .fill(primaryColor)
                        .offset(y: yOffsetTop)
                        .animation(
                            Animation
                                .easeInOut(duration: timing)
                                .repeatForever(autoreverses: true)
                                .delay(timing / Double(maxCounter) * Double(index))
                        )
                        .scaleEffect(isAnimating ? 0.8 : 1.0)
                        .opacity(isAnimating ? 0.8 : 1.0)
                        .animation(Animation.easeInOut(duration: timing).repeatForever(autoreverses: true), value: isAnimating)
                }
            }
            
            HStack(spacing: frame.width / 40) {
                ForEach(0..<maxCounter) { index in
                    
                    Circle()
                        .fill(primaryColor)
                        .offset(y: yOffsetBottom)
                        .animation(
                            Animation
                                .easeInOut(duration: timing)
                                .repeatForever(autoreverses: true)
                                .delay(timing / Double(maxCounter) * Double(index))
                        )
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                        .opacity(isAnimating ? 1.0 : 0.8)
                        .animation(Animation.easeInOut(duration: timing).repeatForever(autoreverses: true), value: isAnimating)

                }
            }
        }
        .frame(width: frame.width, height: frame.height, alignment: .center)
        .onAppear {
            isAnimating.toggle()
        }
//        .background(.orange)
    }
    
    var frameHeight: CGFloat {
        frame.height / 2
    }
    
    var yOffsetTop: CGFloat {
        isAnimating ? -frameHeight : frameHeight
    }
    
    var yOffsetBottom: CGFloat {
        isAnimating ? frameHeight : -frameHeight
    }
}

#Preview {
    LoadingDoubleHelix()
}
