//
//  WaveView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 10/11/22.
//

import SwiftUI

struct WaveView: Shape {
    
    var yOffset: CGFloat = 0.5
    
    var animatableData: CGFloat {
        get {
            return yOffset
        }
        set {
            return yOffset = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        path.addCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY),
            control1: CGPoint(x: rect.maxX * 0.75, y: rect.maxY - (rect.maxY * yOffset)),
            control2: CGPoint(x: rect.maxX * 0.25, y: rect.maxY + (rect.maxY * yOffset)))
        path.closeSubpath()
        return path
    }
}

struct WaveView_Previews: PreviewProvider {
    static var previews: some View {
        WaveView(yOffset: 0.9)
            .stroke(Color.red, lineWidth: 5)
            .frame(height: 200)
            .background(Color.blue)
            .padding()
    }
}
