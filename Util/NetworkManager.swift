//
//  NetworkManager.swift
//  GardenLocator
//
//  Created by Michael Rommel on 24.04.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//
// credits: https://medium.freecodecamp.org/how-to-handle-internet-connection-reachability-in-swift-34482301ea57

import Foundation
import Reachability

class NetworkManager: NSObject {

    var reachability: Reachability?
    typealias ReachabilityHander = (NetworkManager?) -> ()

    override init() {
        super.init()

        // Initialise reachability
        reachability = Reachability()

        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            // Start the network status notifier
            try reachability?.startNotifier()
        } catch {
            fatalError("Unable to start notifier")
        }
    }

    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try self.reachability?.startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    // Network is reachable
    func isReachable(completed: ReachabilityHander) {
        if self.reachability?.connection != .none {
            completed(self)
        }
    }
    
    // Network is unreachable
    func isUnreachable(completed: ReachabilityHander) {
        if self.reachability?.connection == .none {
            completed(self)
        }
    }
    
    // Network is reachable via WWAN/Cellular
    func isReachableViaWWAN(completed: ReachabilityHander) {
        if self.reachability?.connection == .cellular {
            completed(self)
        }
    }
    
    // Network is reachable via WiFi
    func isReachableViaWiFi(completed: ReachabilityHander) {
        if self.reachability?.connection == .wifi {
            completed(self)
        }
    }
}
