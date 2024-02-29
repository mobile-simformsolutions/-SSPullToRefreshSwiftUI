//
//  LottieSwiftUIView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 28/02/24.
//

import SwiftUI
import Lottie

struct LottieSwiftUIConfiguration: RefreshViewConfig {
    var backgroundColor: Color
    let lottieFileName: String
}

struct LottieSwiftUIView: View {
    let config: LottieSwiftUIConfiguration
    @Binding var isPlaying: Bool
    let playbackPaused = LottiePlaybackMode.paused(at: .progress(0))
    let playbackLoop = LottiePlaybackMode.playing(.fromProgress(0, toProgress: 1, loopMode: .loop))
    
    var body: some View {
        
            LottieView(animation: .named(config.lottieFileName))
                .playbackMode(isPlaying ? playbackLoop : playbackPaused)
                .background(config.backgroundColor)
//            Button {
//                if playbackMode == LottiePlaybackMode.paused(at: .progress(0)) {
//                    // if paused then play
//                    playbackMode = .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
//                } else {
//                    playbackMode = LottiePlaybackMode.paused(at: .progress(0))
//                }
//            } label: {
//                if playbackMode == LottiePlaybackMode.paused(at: .progress(0)) {
//                    Image(systemName: "play.fill")
//                } else {
//                    Image(systemName: "stop.fill")
//                }
//            }
        
    }
}

#Preview {
    LottieSwiftUIView(config: LottieSwiftUIConfiguration(backgroundColor: .green, lottieFileName: "ColorsAnimation"), isPlaying: .constant(true))
}
