//
//  RXNetworkMonitor.swift
//  NetworkMonitor
//
//  Created by Rojin on 8/24/22.
//

import Foundation
import Network
import RxSwift

final class RXNetworkMonitor {
    static let shared = RXNetworkMonitor()
    
    private let queue = DispatchQueue(label: "RXNetworkMonitorQueue")
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected = PublishSubject<Bool>()
    public private(set) var currentConnectionType = PublishSubject<NWInterface.InterfaceType>()
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected.onNext(path.status == .satisfied)
                
                guard let interface = NWInterface.InterfaceType.allCases.filter({ path.usesInterfaceType($0) }).first else { return }
                self?.currentConnectionType.onNext(interface)
            }
        }
        monitor.start(queue: queue)
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
}
