//
//  ViewController.swift
//  NetworkMonitor
//
//  Created by Rojin on 8/24/22.
//

import UIKit
import RxSwift
import Combine

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Network monitor with RXSwift
        //        RXNetworkMonitor.shared.isConnected.subscribe(onNext: { connected in
        //            if connected {
        //                print("Connection is OK ✅")
        //            } else {
        //                print("Connection lost ❌")
        //            }
        //        }).disposed(by: disposeBag)
        //
        
        //MARK: Network monitor with Combine
        CombineNetworkMonitor.shared.isConnected.sink { connected in
            if connected {
                print("Connection is OK ✅")
            } else {
                print("Connection lost ❌")
            }
        }.store(in: &cancellables)
        
    }
    
    
}

