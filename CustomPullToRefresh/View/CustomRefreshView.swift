//
//  CustomRefreshView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 01/11/22.
//

import SwiftUI

//struct CustomRefreshView<T: View>: View {
//    
//    var configuration: RefreshViewConfig
//    var content: T
//    var onRefresh: () async -> ()
//    
//    init(configuration: RefreshViewConfig,
//         @ViewBuilder content: @escaping () -> T,
//         onRefresh: @escaping () async-> ()) {
//        
//        self.configuration = configuration
//        self.content = content()
//        self.onRefresh = onRefresh
//    }
//    
//    var refreshViewHeight: CGFloat = 150
//    // let scrollViewCoordinate = "scrollView"
//    @StateObject var scrollConfig: ScrollViewConfig = .init()
//
//    var body: some View {
//        
//        ScrollView(.vertical) {
//            
//            VStack(spacing: 0) {
//                
//                refreshView()
//                
//                    .scaleEffect(scrollConfig.isEligible ? 1 : 0.001)
//                    .animation(.easeInOut(duration: 0.2), value: scrollConfig.isEligible)
//                    .overlay(content: {
//                        VStack(spacing: 12) {
//                            Image(systemName: "arrow.down")
//                                .font(.caption.bold())
//                                .foregroundColor(.white)
//                                .rotationEffect(.init(degrees: scrollConfig.progress * 180))
//                                .padding(8)
//                                .background(.primary,in: Circle())
//                            
//                            Text("Pull to refresh")
//                                .font(.caption.bold())
//                                .foregroundColor(.primary)
//                        }
//                        .opacity(scrollConfig.isEligible ? 0 : 1)
//                        .animation(.easeInOut(duration: 0.25), value: scrollConfig.isEligible)
//                    })
//                    .frame(height: refreshViewHeight * scrollConfig.progress)
//                    .opacity(scrollConfig.progress)
//                    .offset(y: scrollConfig.isEligible ? -(scrollConfig.contentOffset < 0 ? 0 : scrollConfig.contentOffset) : -(scrollConfig.scrollOffset < 0 ? 0 : scrollConfig.scrollOffset))
//                
//                content
//            }
//            .offset(coordinateSpace: "SCROLL") { offset in
//                
//                scrollConfig.contentOffset = offset
//                
//                if !scrollConfig.isEligible && !scrollConfig.isRefreshing {
//                    var progress = offset / refreshViewHeight
//                    
//                    progress = min(max(progress, 0), 1)
//                    
//                    scrollConfig.scrollOffset = offset
//                    scrollConfig.progress = progress
//                    
//                    if offset > refreshViewHeight && !scrollConfig.isEligible {
//                        scrollConfig.isEligible = true
//                    }
//                }
//                
//                if scrollConfig.isEligible && !scrollConfig.isRefreshing {
//                    scrollConfig.isRefreshing = true
//                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//                }
//            }
//        }
//        .coordinateSpace(name: "SCROLL")
//        .onChange(of: scrollConfig.isRefreshing) { newValue in
//            
//            guard newValue else { return }
//            
//            Task {
//                await onRefresh()
//                withAnimation(.easeInOut(duration: 0.25)) {
//                    scrollConfig.progress = 0
//                    scrollConfig.isEligible = false
//                    scrollConfig.isRefreshing = false
//                    scrollConfig.scrollOffset = 0
//                }
//            }
//        }
//    }
//    
//    private func refreshView() -> AnyView {
//        
//        if let _ = (configuration as? LottieUIKitConfiguration) {
//            
//            return AnyView(LottieUIKitView(config: configuration as! LottieUIKitConfiguration, isPlaying: $scrollConfig.isRefreshing))
//            
//        } else if let _ = (configuration as? RotatingImageConfiguration) {
//            
//            return AnyView(RotatingImage(config: configuration as! RotatingImageConfiguration))
//            
//        } else if let _ = (configuration as? WaveConfiguration) {
//            
//            return AnyView(AnimatedWavesView(config: configuration as! WaveConfiguration, animate: $scrollConfig.isRefreshing))
//
//        } else if let _ = (configuration as? PulseConfiguration) {
//            
//            return AnyView(PulseView(config: configuration as! PulseConfiguration, shouldAnimate: $scrollConfig.isRefreshing))
//
//        }
//        
//        return AnyView(Color.clear)
//    }
//}
//
//struct CustomRefreshView_Previews: PreviewProvider {
//    
//    static let config = PulseConfiguration(backgroundColor: .black, pulseColor: .green, circleColor: .red, shadowColor: .orange)
//    
//    static var previews: some View {
//        CustomRefreshView(configuration: config) {
//            Rectangle()
//                .fill(.red)
//                .frame(height: 200)
//        } onRefresh: {
//            try? await Task.sleep(nanoseconds: 3_000_000_000)
//        }
//    }
//}

class ScrollViewConfig: NSObject, ObservableObject {
    
    @Published var isEligible: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var scrollOffset: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
    @Published var progress: CGFloat = 0
    
}

extension View {
    
    @ViewBuilder
    func offset(coordinateSpace: String, offset: @escaping (CGFloat) -> ()) -> some View {
        background {
            GeometryReader { proxy in
                let minY = proxy.frame(in: .named(coordinateSpace)).minY
                
                Text("")
                    .preference(key: ScrollViewOffsetPreferenceKey.self, value: minY)
                    .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                        offset(value)
                    }
            }
        }
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
