//
//  RefreshViewConfiguration.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 16/11/22.
//

import SwiftUI

protocol BackgroundColorChangeableProtocol {
    var backgroundColor: Color { get set }
}

protocol RefreshViewConfig: BackgroundColorChangeableProtocol { }
