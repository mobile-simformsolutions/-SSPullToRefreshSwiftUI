//
//  IdentifyPlatformView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 29/11/22.
//

import SwiftUI

struct IdentifyPlatformView: View {
    var body: some View {
        if Helper.hasDynamicIsland() {
            Text("has DynamicIsland")
        } else {
            Text("NO DynamicIsland")
        }
    }
}

struct IdentifyPlatformView_Previews: PreviewProvider {
    static var previews: some View {
        IdentifyPlatformView()
    }
}
