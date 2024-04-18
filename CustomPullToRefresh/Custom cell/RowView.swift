//
//  RandomImageRowView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 07/03/24.
//

import SwiftUI

struct RowView: View {
    
    let randomImage: RandomImage
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(randomImage.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(randomImage.name)
                Text(randomImage.description)
                    .font(.caption)
            }
            .padding(.trailing, 10)
            .padding(.vertical, 5)
            .padding(.top, -7)
        }
    }
}

#Preview {
    RowView(randomImage: RandomImage.example1())
        .padding()
}
