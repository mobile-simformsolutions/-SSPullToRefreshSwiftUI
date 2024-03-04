//
//  StringPathView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 01/03/24.
//

import SwiftUI

//struct StringPathView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    StringPathView()
//}

struct StringPathView: Shape {
    
    var elapsed = CFAbsoluteTimeGetCurrent() - CFAbsoluteTimeGetCurrent()

    func path(in rect: CGRect) -> Path {
        var path = Path()
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
}
