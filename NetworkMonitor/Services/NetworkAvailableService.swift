//
//  NetworkAvailableService.swift
//  NetworkMonitor
//
//  Created by Rojin on 8/25/22.
//

import Foundation
import RxSwift
import Combine

final class NetWorkAvailableService: ApplicationService {
    
    private let disposeBag = DisposeBag()
    private var cancellables = Set<AnyCancellable>()
    
    private let rxNetworkMonitor = RXNetworkMonitor.shared
    private let combineNetworkMonitor = CombineNetworkMonitor.shared
    
    
    func start() {
        
        
        //MARK: Network monitor with RXSwift
        //        rxNetworkMonitor.startMonitoring()
        //        rxNetworkMonitor.connectivityStatus
        //            .distinctUntilChanged { $0 == $1 }
        //            .subscribe(onNext: { [weak self] status in
        //            if status == .connected {
        //                print("Connection is OK ✅")
        //                let alert = UIAlertController(title: "Nice!", message: "You have internet...", preferredStyle: .alert)
        //                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        //                DispatchQueue.main.async {
        //                    if let keyWindow = UIApplication.shared.mainKeyWindow {
        //                        keyWindow.rootViewController?.present(alert, animated: true, completion: nil)
        //                    }
        //                }
        //            } else {
        //                print("Connection lost ❌")
        //                let alert = UIAlertController(title: "Warning!", message: "You do not have internet at the moment...", preferredStyle: .alert)
        //                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        //                DispatchQueue.main.async {
        //                    if let keyWindow = UIApplication.shared.mainKeyWindow {
        //                        keyWindow.rootViewController?.present(alert, animated: true, completion: nil)
        //                    }
        //                }
        //            }
        //        }).disposed(by: disposeBag)
        
        
        //MARK: Network monitor with Combine
        combineNetworkMonitor.startMonitoring()
        combineNetworkMonitor.connectivityStatus
            .removeDuplicates()
            .sink { [weak self] status in
                if status == .connected {
                    print("Connection is OK ✅")
                    let alert = UIAlertController(title: "Nice!", message: "You have internet...", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        if let keyWindow = UIApplication.shared.mainKeyWindow {
                            keyWindow.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    print("Connection lost ❌")
                    let alert = UIAlertController(title: "Warning!", message: "You do not have internet at the moment...", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        if let keyWindow = UIApplication.shared.mainKeyWindow {
                            keyWindow.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        
    }
    
}
