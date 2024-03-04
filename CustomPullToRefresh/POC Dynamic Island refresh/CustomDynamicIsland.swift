//
//  CustomDynamicIsland.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 01/03/24.
//

import SwiftUI

struct CustomDynamicIsland: View {
    @State var isShowing: Bool = false
    
    var body: some View {
        ScrollView {
            Text("World!")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.green)
        .overlay(alignment: .top ) {
            GeometryReader { proxy in
                let size = proxy.size
                NotificationPreview(size: size, show: $isShowing)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    CustomDynamicIsland()
}

struct NotificationPreview: View {
    var size: CGSize
    @Binding var show: Bool
    var body: some View {
        HStack {
            if show {
                LoadingDoubleHelix(color: .white, width: 200)
                    .opacity(show ? 1 : 0)
                    .offset(y: 10)
            }
        }
        // .clipped()
        .blur(radius: show ? 0 : 30)
        .frame(width: show ? size.width - 22 : 126, height: show ? 100 : 37.33)
        .background {
            RoundedRectangle(cornerRadius: show ? 50 : 63, style: .continuous)
                .fill(.black)
        }
        .clipped()
        .offset(y: 11)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: show)
        .onTapGesture {
            show.toggle()
        }
    }
}
