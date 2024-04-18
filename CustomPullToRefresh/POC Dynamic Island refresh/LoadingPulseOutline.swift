//
//  LoadingPulseOutline.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 08/03/24.
//

import SwiftUI

struct LoadingPulseOutline: View {
    
    // MARK: - Private variables
    private let timing: Double
    private let maxCounter: Int = 3
    @State private var isAnimating: Bool = false
    private let frame: CGSize = CGSize(width: 350, height: 350)
    
    // MARK: - Instance variables
    let primaryColor: Color
    
    /// Initialise loading pulse outline refresh animation
    /// - Parameters:
    ///   - color: set SwiftUI color
    ///   - speed: Provide 'PulsingSpeed'
    init(color: Color = .white, speed: PulsingSpeed = .medium) {
        timing = speed.value * 4
        primaryColor = color
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<maxCounter, id: \.self) { index in
                Circle()
                    .stroke(
                        primaryColor.opacity(isAnimating ? 0.0 : 1.0),
                        style: StrokeStyle(lineWidth: isAnimating ? 0.0 : 10.0))
                    .scaleEffect(isAnimating ? 1.0 : 0.0)
                    .animation(.easeOut(duration: timing).repeatForever(autoreverses: false).delay(Double(index) * timing / Double(maxCounter) / Double(maxCounter)), value: isAnimating)
            }
        }
        .frame(width: frame.width, height: frame.height, alignment: .center)
        .onAppear {
            isAnimating.toggle()
        }
    }
}

#Preview {
    LoadingPulseOutline()
}
