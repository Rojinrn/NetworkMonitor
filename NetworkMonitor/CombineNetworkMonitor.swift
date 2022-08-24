//
//  CombineNetworkMonitor.swift
//  NetworkMonitor
//
//  Created by Rojin on 8/24/22.
//

import Foundation
import Combine
import Network

final class CombineNetworkMonitor {
    static let shared = CombineNetworkMonitor()
    
    private let queue = DispatchQueue(label: "CombineNetworkMonitorQueue")
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected = PassthroughSubject<Bool, Never>()
    public private(set) var currentConnectionType = PassthroughSubject<NWInterface.InterfaceType, Never>()
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected.send(path.status == .satisfied)
                
                guard let interface = NWInterface.InterfaceType.allCases.filter({ path.usesInterfaceType($0) }).first else { return }
                self?.currentConnectionType.send(interface)
            }
        }
        monitor.start(queue: queue)
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
}
