//
//  LoadingText.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 06/03/24.
//

import SwiftUI

struct LoadingText: View {
    
    private let fontSize: CGFloat
    private let primaryColor: Color
    private var letters = Array("Loading data ...")
    @State private var rotation: Double = 0
    @State private var isSliding: Bool = false
    
    init(loadingText: String, fontSize: CGFloat, color: Color) {
        self.letters = Array(loadingText)
        self.fontSize = fontSize
        self.primaryColor = color
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 0, content: {
                ForEach(0..<letters.count, id:  \.self) { slide in
                    Text(String(letters[slide]))
                        .font(.system(size: fontSize))
                        .foregroundStyle(primaryColor)
                        .scaleEffect(isSliding ? 0.25 : 1)
                        .rotation3DEffect(.degrees(rotation),axis: (x: 0.0, y: 1.0, z: 0.0))
                        .hueRotation(.degrees(isSliding ? 360 : 0))
                        .animation(.easeOut(duration: 1).delay(1).repeatForever(autoreverses: false).delay(Double(slide) / 20), value: isSliding)
                }
            })
        }
        .onAppear(perform: {
            rotation = 360
            isSliding = true
        })
    }
}

#Preview {
    LoadingText(loadingText: "Loading data ...", fontSize: 18, color: Color.blue)
}
