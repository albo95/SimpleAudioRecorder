//
//  NetworkMonitor.swift
//  SimpleAudioRecorder
//
//  Created by Alberto Bruno on 17/02/24.
//

import Foundation
import Network

@Observable
class NetworkMonitor {
    public static var shared: NetworkMonitor = NetworkMonitor()
    private var logger: MyLogger = MyLogger.shared
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            if path.status != .satisfied {
                self?.isConnected = false
            } else {
                self?.isConnected = true
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}

