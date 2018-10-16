//
//  WatchSessionManager.swift
//  Meets Extension
//
//  Created by Hemang on 16/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import UIKit
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    private let session: WCSession = WCSession.default
    
    func startSession() {
        session.delegate = self
        session.activate()
    }
}

// MARK: Application Context
extension WatchSessionManager {
    
    // Sender
    func updateApplicationContext(applicationContext: [String : Any]) throws {
        print("Everyday WatchOS app: updateApplicationContext:")
        do {
            try session.updateApplicationContext(applicationContext)
        } catch let error {
            throw error
        }
    }
    
    // Receiver    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Everyday WatchOS app: didReceiveApplicationContext: applicationContext:")
        // handle receiving application context
        DispatchQueue.main.async {
            // make sure to put on the main queue to update UI!
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Everyday WatchOS app: activationDidCompleteWith: activationState: error")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Everyday WatchOS app: sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Everyday WatchOS app: sessionDidDeactivate")
    }
}
