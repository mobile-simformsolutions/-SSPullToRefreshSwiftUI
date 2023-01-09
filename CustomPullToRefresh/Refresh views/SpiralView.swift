//
//  SpiralView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 01/12/22.
//

import SwiftUI

//struct SpiralView: View {
//    
//    @State private var color: Color = .green
//    @State private var rotation: Double = 0
//    
//    let size: CGFloat = 500
//    let circleCount: Int = 100
//    
//    var body: some View {
//        ZStack {
//            ForEach(0..<circleCount) { i in
//                Circle()
//                    .foregroundColor(color)
//                    .animation(.linear(duration: 3).repeatForever(autoreverses: true), value: color)
//                    .frame(width: 15, height: 15)
//                    .offset(y:-(size/Double(circleCount)) * Double(i))
//                    .rotationEffect(.degrees(1500.0 / Double(circleCount)) * Double(i))
//                    .rotationEffect(.degrees(rotation))
//                    .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotation)
//                    .scaleEffect(Double(i) / 100)
//                    .blur(radius: (Double(i) / 100))
//            }
//        }
//        .onAppear {
//            color = .blue
//            rotation = -360
//        }
//    }
//}
//
//struct SpiralView_Previews: PreviewProvider {
//    static var previews: some View {
//        SpiralView()
//    }
//}
