//
//  LazyContentView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 07/11/22.
//

import SwiftUI

struct SampleRow: View {
    let id: Int
    
    var body: some View {
        Text("Row \(id)")
    }
    
    init(id: Int) {
        print("Loading \(id)")
        self.id = id
    }
    
}

struct LazyContentView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(1...100, id: \.self) { value in
                    //Text("value \(value)")
                    SampleRow(id: value)
                        .background(Color.yellow)
                        // .padding()
                }
            }
        }
        .frame(height: 300)
    }
}

struct LazyContentView_Previews: PreviewProvider {
    static var previews: some View {
        LazyContentView()
    }
}
