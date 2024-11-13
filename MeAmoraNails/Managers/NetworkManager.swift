//
//  NetworkManager.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI
import Network

final class NetworkManager: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkManager")
    
    @Published var isConnected: Bool = true
    
    //anything that is not wifi
    @Published var isExpensive: Bool = false
    
    @Published var isConstrained: Bool = false
    
    @Published var connectionType = NWInterface.InterfaceType.other
    
    init() {
        DispatchQueue.main.async {
            self.monitor.pathUpdateHandler = { path in
                self.isConnected = (path.status == .satisfied)
                self.isExpensive = path.isExpensive
                self.isConstrained = path.isConstrained
                
                Task {
                    await MainActor.run {
                        self.objectWillChange.send()
                    }
                }
            }
            
            self.monitor.start(queue: self.queue)
        }
    }
}
