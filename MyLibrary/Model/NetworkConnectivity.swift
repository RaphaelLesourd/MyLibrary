//
//  NetworkConnectivity.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/11/2021.
//

import Foundation
import Network

class Networkconnectivity {
    
    static let shared = Networkconnectivity()
    
    private let networkMonitor = NWPathMonitor()
    var status: NWPath.Status = .requiresConnection
    
    var isReachable: Bool {
        status == .satisfied
    }
    
    func startMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        networkMonitor.start(queue: queue)
    }
    
    class func isConnectedToNetwork() -> Bool {
        return shared.isReachable
    }
}
