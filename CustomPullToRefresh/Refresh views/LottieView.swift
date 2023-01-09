//
//  LottieView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 16/11/22.
//

import SwiftUI
import Lottie

struct LottieConfiguration: RefreshViewConfig {
    var backgroundColor: Color
    let lottieFileName: String
}

struct LottieView: UIViewRepresentable {
    
    // var fileName: String
    let config: LottieConfiguration
    @Binding var isPlaying: Bool
    internal var lottieTag = 1234
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        addLottieView(toView: view)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.subviews.forEach { view in
            if view.tag == lottieTag, let lottieView = view as? LottieAnimationView {
                isPlaying ? lottieView.play() : lottieView.pause()
            }
        }
    }
    
    func addLottieView(toView: UIView) {
        let lottieView = LottieAnimationView(name: config.lottieFileName, bundle: .main)
        // lottieView.backgroundBehavior = .clear
        lottieView.tag = lottieTag
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            lottieView.widthAnchor.constraint(equalTo: toView.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: toView.heightAnchor)
        ]
        
        toView.addSubview(lottieView)
        toView.addConstraints(constraints)
    }
}

struct UIKitAnimationView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
