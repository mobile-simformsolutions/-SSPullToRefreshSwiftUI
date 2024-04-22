//
//  CombinedRefreshView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 29/11/22.
//

import SwiftUI

public typealias EndRefresh = () -> Void
public typealias Action = (@escaping EndRefresh) -> Void

struct CombinedRefreshView<T: View>: View {
    
    // var configuration: RefreshViewConfig
    var refreshViewType: RefreshViewType
    var dynamicIslandType: DynamicIslandType?
    @Binding var isRefreshing: Bool
    var content: T
    var refreshInitiated: () -> ()
    
    init(refreshViewType: RefreshViewType,
         dynamicIslandType: DynamicIslandType? = nil,
         isRefreshing: Binding<Bool>,
         @ViewBuilder content: @escaping () -> T,
         refreshInitiated: @escaping () -> ()) {
        // self.configuration = configuration
        self.refreshViewType = refreshViewType
        self.dynamicIslandType = dynamicIslandType
        _isRefreshing = isRefreshing
        self.content = content()
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
                    isRefreshing = true
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
        .overlay(alignment: .top ) {
            if Helper.hasDynamicIsland() && dynamicIslandType != nil {
                GeometryReader { proxy in
                    let size = proxy.size
                    NotificationPreview(dynamicIslandType: dynamicIslandType ?? .doubleHelix(color: .white), size: size, show: $isRefreshing)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                .ignoresSafeArea()
            }
        }
        .coordinateSpace(name: "SCROLL")
        .onChange(of: isRefreshing, perform: { newValue in
            guard scrollConfig.isRefreshing else { return }
            guard !newValue else { return }
            withAnimation(.easeInOut(duration: 0.25)) {
                scrollConfig.progress = 0
                scrollConfig.isEligible = false
                scrollConfig.isRefreshing = false
                scrollConfig.scrollOffset = 0
            }
        })
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
                .offset(y: contentYOffset)
        }
    }
    
    private var contentYOffset: CGFloat {
        if scrollConfig.progress == 1.0 && scrollConfig.isEligible {
            if Helper.hasDynamicIsland() && dynamicIslandType != nil {
                50
            } else {
                150
            }
        } else {
            0
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
                .offset(y: 11)
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
                .opacity(scrollConfig.isEligible ? 1 : 0)
                .frame(width: UIScreen.main.bounds.width, height: refreshViewHeight * scrollConfig.progress)
        }
        .animation(.easeInOut(duration: 0.25), value: scrollConfig.isEligible)
        .opacity(scrollConfig.progress)
        .offset(y: newOffset)
    }
    
    private func refreshView() -> AnyView {
        if dynamicIslandType != nil && Helper.hasDynamicIsland() {
            return AnyView(Color.clear)
        }
        
        switch refreshViewType {
            
        case .rotatingImage(backgroundColor: let backgroundColor, imageName: let imageName):
            return AnyView(RotatingImage(config: RotatingImageConfiguration(backgroundColor: backgroundColor, rotatingImage: imageName)))
            
        case .wave(backgroundColor: let backgroundColor, waveColor: let waveColor):
            return AnyView(AnimatedWavesView(config: WaveConfiguration(backgroundColor: backgroundColor, waveColor: waveColor), animate: $scrollConfig.isRefreshing))
            
        case .pulse(backgroundColor: let backgroundColor, pulseColor: let pulseColor, circleColor: let circleColor, shadowColor: let shadowColor):
            return AnyView(PulseView(backgroundColor: backgroundColor, pulseColor: pulseColor, circleColor: circleColor, shadowColor: shadowColor, shouldAnimate: $scrollConfig.isRefreshing))
            
        case .lottieUIKit(backgroundColor: let backgroundColor, lottieFileName: let lottieFileName):
            return AnyView(LottieUIKitView(config: LottieUIKitConfiguration(backgroundColor: backgroundColor, lottieFileName: lottieFileName), isPlaying: $scrollConfig.isRefreshing))
            
        case .lottieSwiftUI(backgroundColor: let backgroundColor, lottieFileName: let lottieFileName):
            return AnyView(LottieSwiftUIView(config: LottieSwiftUIConfiguration(backgroundColor: backgroundColor, lottieFileName: lottieFileName), isPlaying: $scrollConfig.isRefreshing))
        }
    }
}

struct CombinedRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedRefreshView(refreshViewType: .lottieSwiftUI(backgroundColor: .clear, lottieFileName: "PaperPlane"), isRefreshing: .constant(false)) {
            Rectangle()
                .fill(.red)
                .frame(height: 200)
        } refreshInitiated: {
            print("refresh initiated")
        }
    }
}
