//
//  RXNetworkMonitor.swift
//  NetworkMonitor
//
//  Created by Rojin on 8/24/22.
//

import Foundation
import Network
import RxRelay

enum ConnectivityStatus {
    case connected
    case disconnected
    case requiresConnection
}

final class RXNetworkMonitor {
    static let shared = RXNetworkMonitor()
    
    private let queue = DispatchQueue(label: "RXNetworkMonitorQueue")
    private let monitor: NWPathMonitor
    
    public private(set) var connectivityStatus = PublishRelay<ConnectivityStatus>()
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    // Starts monitoring connectivity changes
    public func startMonitoring() {
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.connectivityStatus.accept(self.getConnectivityFrom(status: path.status))
            }
        }
        
        monitor.start(queue: queue)
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    // Converts NWPath.Status into ConnectivityStatus
    private func getConnectivityFrom(status: NWPath.Status) -> ConnectivityStatus {
        switch status {
        case .satisfied: return .connected
        case .unsatisfied: return .disconnected
        case .requiresConnection: return .requiresConnection
        @unknown default: fatalError()
        }
    }
    
}
