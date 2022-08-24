//
//  NWInterface+Extension.swift
//  NetworkMonitor
//
//  Created by Rojin on 8/24/22.
//

import Network

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}

