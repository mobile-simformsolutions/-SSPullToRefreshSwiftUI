//
//  CustomDynamicIsland.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 01/03/24.
//

import SwiftUI

//struct CustomDynamicIsland: View {
//    @State var isShowing: Bool = false
//    
//    var body: some View {
//        ScrollView {
//            Text("World!")
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.green)
//        .overlay(alignment: .top ) {
//            GeometryReader { proxy in
//                let size = proxy.size
//                NotificationPreview(dynamicIslandType: .doubleHelix, size: size, show: $isShowing)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//            }
//            .ignoresSafeArea()
//        }
//    }
//}
//
//#Preview {
//    CustomDynamicIsland()
//}

struct NotificationPreview: View {
    var dynamicIslandType: DynamicIslandType
    var size: CGSize
    @Binding var show: Bool
    var body: some View {
        HStack {
            if show {
                switch dynamicIslandType {
                    
                case .doubleHelix(let color):
                    LoadingDoubleHelix(color: color, width: 200)
                        .opacity(show ? 1 : 0)
                        .offset(y: 10)
                    
                case .textAnimation(let title):
                    LoadingText(loadingText: title, fontSize: 20, color: .white)
                        .opacity(show ? 1 : 0)
                    
                case .pulseOutline(let color, let speed):
                    LoadingPulseOutline(color: color, speed: speed)
                }
            }
        }
        .blur(radius: show ? 0 : 30)
        .frame(width: show ? size.width - 22 : 126, height: show ? 100 : 37.33)
        .background {
            RoundedRectangle(cornerRadius: show ? 50 : 63, style: .continuous)
                .fill(.black)
                .clipped()
        }
        .clipped()
        .offset(y: 11)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: show)
        .onTapGesture {
            show.toggle()
        }
    }
}
