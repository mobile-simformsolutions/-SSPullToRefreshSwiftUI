//
//  CardView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 07/03/24.
//

import SwiftUI

struct CardView: View {
    
    let randomImage: RandomImage
    let padding: CGFloat = 10
    
    var body: some View {
        Image(randomImage.imageName)
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
            .shadow(radius: 5)
            .overlay(alignment: .bottomTrailing) {
                Text(randomImage.name)
                    .bold()
                    .padding()
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 5)
                    .offset(y: 5)
            }
    }
}

#Preview {
    CardView(randomImage: RandomImage.example1())
        .padding()
}
