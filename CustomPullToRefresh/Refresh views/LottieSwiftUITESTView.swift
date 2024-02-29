//
//  LottieSwiftUIView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 28/02/24.
//

import SwiftUI
import Lottie

struct LottieSwiftUITESTView: View {
    @State var isPlaying: Bool = true
    @State var playbackMode = LottiePlaybackMode.paused(at: .progress(0))
    // @State var playbackMode = LottiePlaybackMode.playing(.toProgress(1, loopMode: .loop))
    
    var body: some View {
        VStack{
            Text("Hello, World!")
            //        LottieView(animation: .named("PaperPlane"))
            //            .playbackMode(LottiePlaybackMode.playing(1, loopMode: .loop))
            
            //        LottieView(animation: .named("HeartAnimation"))
            //            .playbackMode(playbackMode)
            //            .animationDidFinish { _ in
            //                playbackMode = .paused
            //            }
            
            LottieView(animation: .named("PaperPlane"))
                .playbackMode(playbackMode)
            
            Button {
                // playbackMode = .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
                
                if playbackMode == LottiePlaybackMode.paused(at: .progress(0)) {
                    // if paused then play
                    playbackMode = .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
                } else {
                    playbackMode = LottiePlaybackMode.paused(at: .progress(0))
                }

                
            } label: {
                if playbackMode == LottiePlaybackMode.paused(at: .progress(0)) {
                    Image(systemName: "play.fill")
                } else {
                    Image(systemName: "stop.fill")
                }
            }
        }
    }
}

#Preview {
    LottieSwiftUITESTView()
}
