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
    
    public private(set) var connectivityStatus = PassthroughSubject<ConnectivityStatus, Never>()

    private init() {
        monitor = NWPathMonitor()
    }
    
    // Starts monitoring connectivity changes
    public func startMonitoring() {

        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.connectivityStatus.send(self.getConnectivityFrom(status: path.status))
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
