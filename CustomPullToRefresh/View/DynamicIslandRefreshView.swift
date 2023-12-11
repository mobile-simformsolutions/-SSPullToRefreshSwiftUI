//
//  DynamicIslandRefreshView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 17/11/22.
//

import SwiftUI

struct DynamicIslandRefreshView<Content: View>: View {
    
    var content: Content
    var onRefresh: ()async->()
    
    init(@ViewBuilder content: @escaping ()->Content,
         onRefresh: @escaping ()async->()) {
        
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    @StateObject var scrollDelegate: ScrollViewModel = .init()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                
                // refreshView()
                Rectangle()
                    .fill(.clear)
                    .frame(height: 150 * scrollDelegate.progress)
                
                content
                
            }
            .offset(coordinateSpace: "SCROLL") { offset in
                
                scrollDelegate.contentOffset = offset
                // print("offset: \(offset)")
                if !scrollDelegate.isEligible {
                    var progress = offset / 150
                    progress = (progress < 0 ? 0 : progress)
                    progress = (progress > 1 ? 1 : progress)
                    
                    scrollDelegate.scrollOffset = offset
                    scrollDelegate.progress = progress
                }
                
                if scrollDelegate.isEligible && !scrollDelegate.isRefreshing {
                    scrollDelegate.isRefreshing = true
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        .overlay(alignment: .top, content: {
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
        })
        .coordinateSpace(name: "SCROLL")
//        .onAppear(perform: scrollDelegate.addGesture)
//        .onDisappear(perform: scrollDelegate.removeGesture)
        .onChange(of: scrollDelegate.isRefreshing) { newValue in
            if newValue {
                Task {
                    await onRefresh()
                    withAnimation(.easeInOut(duration: 0.25)) {
                        scrollDelegate.progress = 0
                        scrollDelegate.isEligible = false
                        scrollDelegate.isRefreshing = false
                        scrollDelegate.scrollOffset = 0
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func canvasSymbol(isCircle: Bool = false) -> some View {
        if isCircle {
            let contentOffset = scrollDelegate.isEligible ? (scrollDelegate.contentOffset > 95 ? scrollDelegate.contentOffset : 95) : scrollDelegate.scrollOffset
            let offset = scrollDelegate.scrollOffset > 0 ? contentOffset : 0
            Circle()
                .fill(.black)
                .frame(width: 37, height: 37)
                .offset(y: offset)
        } else {
            Capsule()
                .fill(.black)
                .frame(width: 126, height: 37)
        }
    }
    
    @ViewBuilder
    func refreshArrowAndProgressView() -> some View {
        
        let contentOffset = scrollDelegate.isEligible ? (scrollDelegate.contentOffset > 95 ? scrollDelegate.contentOffset : 95) : scrollDelegate.scrollOffset
        let offset = scrollDelegate.scrollOffset > 0 ? contentOffset : 0
        
        ZStack {
            Image(systemName: "arrow.down")
                .font(.caption.bold())
                .foregroundColor(.white)
                .frame(width: 38, height: 38)
                .rotationEffect(.init(degrees: scrollDelegate.progress * 180))
                .opacity(scrollDelegate.isEligible ? 0 : 1)
            
            ProgressView()
                .tint(.white)
                .frame(width: 38, height: 38)
                .opacity(scrollDelegate.isEligible ? 1 : 0)
        }
        .animation(.easeInOut(duration: 0.25), value: scrollDelegate.isEligible)
        .opacity(scrollDelegate.progress)
        .offset(y: offset)
    }
}

struct DynamicIslandRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicIslandRefreshView() {
            VStack {
                Rectangle()
                    .fill(.red)
                .frame(height: 200)
                
                Rectangle()
                    .fill(.yellow)
                .frame(height: 200)
            }
        } onRefresh: {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
    }
}

class ScrollViewModel: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    
    @Published var isEligible: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var scrollOffset: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
    @Published var progress: CGFloat = 0
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc
    func onGestureChange(gesture: UIPanGestureRecognizer) {
        if gesture.state == .cancelled || gesture.state == .ended {
            print("User released touch")
        
            if !isRefreshing {
                isEligible = scrollOffset > 150
            }
        }
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

