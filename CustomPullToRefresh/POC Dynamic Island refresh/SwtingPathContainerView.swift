//
//  SwtingPathContainerView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 01/03/24.
//

import SwiftUI

struct SwtingPathContainerView: View {
    
    let startTime = CFAbsoluteTimeGetCurrent()
    @State var elapsed = CFAbsoluteTimeGetCurrent() - CFAbsoluteTimeGetCurrent()
    
    var body: some View {
        ZStack(alignment: .top, content: {
            StringPathView(elapsed: elapsed)
                .onAppear(perform: {
                    Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                        self.elapsed = CFAbsoluteTimeGetCurrent() - self.startTime
                    }
                })
                .background(.blue)
                .frame(height: 100)
        })
    }
}

#Preview {
    SwtingPathContainerView()
}
