//
//  CombinedRefreshView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 29/11/22.
//

import SwiftUI

struct CombinedRefreshView<T: View>: View {
    
    var configuration: RefreshViewConfig
    var content: T
    var onRefresh: () async -> ()
    var refreshInitiated: () -> ()
    
    init(configuration: RefreshViewConfig,
         @ViewBuilder content: @escaping () -> T,
         onRefresh: @escaping () async-> (),
         refreshInitiated: @escaping () -> ()) {
        
        self.configuration = configuration
        self.content = content()
        self.onRefresh = onRefresh
        self.refreshInitiated = refreshInitiated
        
    }
    
    var refreshViewHeight: CGFloat = 150
    @StateObject var scrollConfig: ScrollViewConfig = .init()

    var body: some View {
        
        ScrollView(.vertical) {
            
             mainContentView()
            .offset(coordinateSpace: "SCROLL") { offset in
                
                scrollConfig.contentOffset = offset
                
                if !scrollConfig.isEligible && !scrollConfig.isRefreshing {
                    var progress = offset / refreshViewHeight
                    
                    progress = min(max(progress, 0), 1)
                    
                    scrollConfig.scrollOffset = offset
                    scrollConfig.progress = progress
                    
                    if offset > refreshViewHeight && !scrollConfig.isEligible {
                        scrollConfig.isEligible = true
                    }
                }
                
                if scrollConfig.isEligible && !scrollConfig.isRefreshing {
                    scrollConfig.isRefreshing = true
                    refreshInitiated()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        .overlay(alignment: .top, content: {
            if Helper.hasDynamicIsland() {
                dynamicIslandCapsuleView()
            } else {
                Color.clear
            }
        })
        .coordinateSpace(name: "SCROLL")
        .onChange(of: scrollConfig.isRefreshing) { newValue in
            
            guard newValue else { return }
            
            Task {
                await onRefresh()
                withAnimation(.easeInOut(duration: 0.25)) {
                    scrollConfig.progress = 0
                    scrollConfig.isEligible = false
                    scrollConfig.isRefreshing = false
                    scrollConfig.scrollOffset = 0
                }
            }
        }
    }
    
    private func mainContentView() -> AnyView {
        if Helper.hasDynamicIsland() {
            return AnyView(dynamicIslandContentView)
        } else {
            return AnyView(normalContentView)
        }
    }
    
    private var dynamicIslandContentView: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(.clear)
                .frame(height: 150 * scrollConfig.progress)
            
            content
                .offset(y: (scrollConfig.progress == 1.0 && scrollConfig.isEligible) ? 150 : 0)
        }
    }
    
    @ViewBuilder
    func dynamicIslandCapsuleView() -> some View {
        ZStack {
            Capsule()
                .fill(.black)
        }
        .frame(width: 126, height: 37)
        .offset(y: 11)
        .frame(maxHeight: .infinity, alignment: .top)
        .overlay(alignment: .top, content: {
            Canvas { context, size in
                context.addFilter(.alphaThreshold(min: 0.5, color: .black))
                context.addFilter(.blur(radius: 10))
                context.drawLayer { ctx in
                    for indexx in [1,2] {
                        if let resolvedView = context.resolveSymbol(id: indexx) {
                            ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: 30))
                        }
                    }
                }
            } symbols: {
                canvasSymbol()
                    .tag(1)

                canvasSymbol(isCircle: true)
                    .tag(2)
            }
            .allowsHitTesting(false)
        })
        .overlay(alignment: .top, content: {
            refreshArrowAndProgressView()
        })
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func canvasSymbol(isCircle: Bool = false) -> some View {
        if isCircle {
            let contentOffset = scrollConfig.isEligible ? (scrollConfig.contentOffset > 95 ? scrollConfig.contentOffset : 95) : scrollConfig.scrollOffset
            let offset = scrollConfig.scrollOffset > 0 ? contentOffset : 0
            Circle()
                .fill(.black)
                .frame(width: 37, height: 37)
                .offset(y: offset)
                .opacity(scrollConfig.isEligible ? 0 : 1) // Show/Hide when refresh view is being displayed
            
        } else {
            Capsule()
                .fill(.black)
                .frame(width: 126, height: 37)
        }
    }
    
    private var normalContentView: some View {
        ZStack(alignment: .top) {
            refreshView()
                .scaleEffect(scrollConfig.isEligible ? 1 : 0.001)
                .animation(.easeInOut(duration: 0.2), value: scrollConfig.isEligible)
                .overlay(content: {
                    VStack(spacing: 12) {
                        Image(systemName: "arrow.down")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .rotationEffect(.init(degrees: scrollConfig.progress * 180))
                            .padding(8)
                            .background(.primary,in: Circle())
                        
                        Text("Pull to refresh")
                            .font(.caption.bold())
                            .foregroundColor(.primary)
                    }
                    .opacity(scrollConfig.isEligible ? 0 : 1)
                    .animation(.easeInOut(duration: 0.25), value: scrollConfig.isEligible)
                })
                .frame(height: refreshViewHeight * scrollConfig.progress)
                .opacity(scrollConfig.progress)
                .offset(y: scrollConfig.isEligible ? -(scrollConfig.contentOffset < 0 ? 0 : scrollConfig.contentOffset) : -(scrollConfig.scrollOffset < 0 ? 0 : scrollConfig.scrollOffset))
            
            content
                .offset(y: (scrollConfig.progress == 1.0 && scrollConfig.isEligible) ? 150 : 0)
        }
    }
    
    @ViewBuilder
    func refreshArrowAndProgressView() -> some View {
        
        let contentOffset = scrollConfig.isEligible ? (scrollConfig.contentOffset > 95 ? scrollConfig.contentOffset : 95) : scrollConfig.scrollOffset
        let offset = scrollConfig.scrollOffset > 0 ? contentOffset : 0
        let newOffset = Helper.hasDynamicIsland() ? (offset - (offset/3.5)) : offset
        
        ZStack {
            Image(systemName: "arrow.down")
                .tint(.white)
                .font(.caption.bold())
                .foregroundColor(.white)
                .frame(width: 38, height: 38)
                .rotationEffect(.init(degrees: scrollConfig.progress * 180))
                .opacity(scrollConfig.isEligible ? 0 : 1)
            
            refreshView()
                .offset(y: 11)
                .opacity(scrollConfig.isEligible ? 1 : 0)
                .frame(width: UIScreen.main.bounds.width, height: refreshViewHeight * scrollConfig.progress)
        }
        .animation(.easeInOut(duration: 0.25), value: scrollConfig.isEligible)
        .opacity(scrollConfig.progress)
        .offset(y: newOffset)
    }
    
    private func refreshView() -> AnyView {
        if let _ = (configuration as? LottieConfiguration) {
            
            return AnyView(LottieView(config: configuration as! LottieConfiguration, isPlaying: $scrollConfig.isRefreshing))
            
        } else if let _ = (configuration as? RotatingImageConfiguration) {
            
            return AnyView(RotatingImage(config: configuration as! RotatingImageConfiguration))
            
        } else if let _ = (configuration as? WaveConfiguration) {
            
            return AnyView(AnimatedWavesView(animate: $scrollConfig.isRefreshing, config: configuration as! WaveConfiguration))
            
        } else if let _ = (configuration as? PulseConfiguration) {
            
            return AnyView(PulseView(shouldAnimate: $scrollConfig.isRefreshing, config: configuration as! PulseConfiguration))
            
        }
        
        return AnyView(Color.clear)
    }
}

struct CombinedRefreshView_Previews: PreviewProvider {    
    // static let config = PulseConfiguration(backgroundColor: .black, pulseColor: .green, circleColor: .red)
    static let config = LottieConfiguration(backgroundColor: .green, lottieFileName: "PaperPlane")
    
    static var previews: some View {
        CombinedRefreshView(configuration: config) {
            Rectangle()
                .fill(.red)
                .frame(height: 200)
        } onRefresh: {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
        } refreshInitiated: {
            print("refresh initiated")
        }
    }
}
