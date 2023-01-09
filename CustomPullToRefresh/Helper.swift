//
//  Helper.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 29/11/22.
//

import UIKit

class Helper {
    
    static let shared = Helper()
    
    init() {}
    
    static func hasDynamicIsland() -> Bool {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            let nameSimulator = simulatorModelIdentifier
            return nameSimulator == "iPhone15,2" || nameSimulator == "iPhone15,3" ? true : false
        }
        
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        let name =  String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        return name == "iPhone15,2" || name == "iPhone15,3" ? true : false
    }
}

