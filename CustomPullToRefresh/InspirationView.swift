//
//  InspirationView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 07/03/24.
//

import SwiftUI

struct InspirationView: View {
    
    @State private var randomImages = RandomImage.samples()
    let rows = Array(repeating: GridItem(.fixed(120), spacing: 0), count: 2)
    
    var body: some View {
//        NavigationView(content: {
            ScrollView {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(randomImages) { image in
                            CardView(randomImage: image)
                        }
                    }
                    .padding()
                }
                .frame(height: 150)
                
                Section {
                    
                    ScrollView(.horizontal) {
                        
                        LazyHGrid(rows: rows, spacing: 0, content: {
                            ForEach(randomImages) { image in
                                TileView(randomImage: image, size: 120, cornerRadius: 0)
                            }
                        })
                    }
                } header: {
                    Text("Second section")
                        .modifier(SectionHeaderStyling())
                        .padding(.leading)
                }
                
                LazyVStack(alignment: .leading, spacing: 10, pinnedViews: .sectionHeaders, content: {
                    Section {
                        ForEach(randomImages) { image in
                            RowView(randomImage: image)
                        }
                    } header: {
                        Text("Third section")
                            .modifier(SectionHeaderStyling())
                    }
                })
                .padding()
            }
//            .navigationTitle("Images")
//        })
    }
}

struct SectionHeaderStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)

    }
}

#Preview {
    InspirationView()
}

