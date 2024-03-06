//
//  LoadingDoubleHelix.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 04/03/24.
//

import SwiftUI

struct LoadingDoubleHelix: View {
    
    // MARK: - Private Variables
    @State private var isAnimating: Bool = false
    private let frame: CGSize
    private let timing: Double
    private let primaryColor: Color
    private let maxCounter: Int = 20
    private let aspectRatio: CGFloat = 1/5 // W100 H30
    private var frameHeight: CGFloat { frame.height / 2 }
    private var yOffsetTop: CGFloat { isAnimating ? -frameHeight : frameHeight }
    private var yOffsetBottom: CGFloat { isAnimating ? frameHeight : -frameHeight }
    
    // MARK: - Initialiser
    init(color: Color = .black, width: CGFloat = 350, speed: Double = 0.6) {
        timing = speed * 2
        primaryColor = color
        frame = CGSize(width: width, height: width * CGFloat(aspectRatio))
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: frame.width / 40) {
                ForEach(0..<maxCounter, id: \.self) { index in
                    Circle()
                        .fill(primaryColor)
                        .offset(y: yOffsetTop)
                        .animation(.easeInOut(duration: timing).repeatForever(autoreverses: true).delay(timing / Double(maxCounter) * Double(index)), value: yOffsetTop)
                        .scaleEffect(isAnimating ? 0.8 : 1.0)
                        .opacity(isAnimating ? 0.7 : 1.0)
                        .animation(Animation.easeInOut(duration: timing).repeatForever(autoreverses: true), value: isAnimating)
                }
            }
            HStack(spacing: frame.width / 40) {
                ForEach(0..<maxCounter, id: \.self) { index in
                    Circle()
                        .fill(primaryColor)
                        .offset(y: yOffsetBottom)
                        .animation(.easeInOut(duration: timing).repeatForever(autoreverses: true).delay(timing / Double(maxCounter) * Double(index)), value: yOffsetBottom)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                        .opacity(isAnimating ? 1.0 : 0.7)
                        .animation(Animation.easeInOut(duration: timing).repeatForever(autoreverses: true), value: isAnimating)

                }
            }
        }
        .frame(width: frame.width, height: frame.height, alignment: .center)
        .onAppear {
            isAnimating.toggle()
        }
    }
}

#Preview {
    LoadingDoubleHelix()
}
