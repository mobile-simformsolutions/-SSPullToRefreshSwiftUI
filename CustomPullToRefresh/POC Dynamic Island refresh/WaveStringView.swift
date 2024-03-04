//
//  WaveStringView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 01/03/24.
//

import SwiftUI

struct WaveStringView: View {
    
    let startTime = CFAbsoluteTimeGetCurrent()
    @State var elapsed = CFAbsoluteTimeGetCurrent() - CFAbsoluteTimeGetCurrent()
    
    private func wave (path: Path) -> Path {
        var path = path
        let viewBoundsHeight: CGFloat = UIScreen.main.bounds.width
        let centerY = viewBoundsHeight / 2
        let amplitude = CGFloat(50) - abs(fmod(CGFloat(elapsed), 3) - 1.5) * 40
        
        func f(_ x: Int) -> CGFloat {
            return sin(((CGFloat (x) / viewBoundsHeight) + CGFloat (elapsed)) * 4 * .pi) * amplitude + centerY
        }
        
        path.move(to: CGPoint(x: 0, y: f(0)))
        for x in stride(from: 0, to: Int(viewBoundsHeight + 9), by: 5) {
            path.addLine(to: CGPoint(x: CGFloat (x), y: f(x)))
        }
        return path
    }
    
    var body: some View {
        let colors: [Color] = [.red, .yellow, .blue, .purple, .orange]
        let gradient = AngularGradient(gradient: Gradient (colors: colors), center: .center)
        
        return Path { path in
            path = wave(path: path)
        }
        .stroke(gradient, lineWidth: 10)
//        .onAppear(perform: {
//            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
//                self.elapsed = CFAbsoluteTimeGetCurrent() - self.startTime
//            }
//        })
    }
}

#Preview {
    WaveStringView()
}
