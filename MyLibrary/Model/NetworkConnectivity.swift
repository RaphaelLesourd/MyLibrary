//
//  NetworkConnectivity.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/11/2021.
//

import Network

/// Singleton patern class  monitring if there is network connection or not.
/// Used only when a image need to be stored in Firebase storage.
/// All other firebase CRUD fonctions avec peristed offline within the app.
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
}
