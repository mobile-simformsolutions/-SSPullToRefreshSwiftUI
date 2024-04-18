//
//  TileView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 07/03/24.
//

import SwiftUI

struct TileView: View {
    
    let randomImage: RandomImage
    let size: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        Image(randomImage.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(radius: 5)
            .clipped()
    }
}

#Preview {
    TileView(randomImage: RandomImage.example1(), size: 300, cornerRadius: 15)
}
