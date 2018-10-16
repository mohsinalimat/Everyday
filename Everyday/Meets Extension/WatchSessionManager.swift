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
// use when your app needs only the latest information
// if the data was not sent, it will be replaced
extension WatchSessionManager {
    // Receiver
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        print("Everyday iOS app: didReceiveApplicationContext: applicationContext:")
        // handle receiving application context
        print(applicationContext)
        DispatchQueue.main.async {
            // make sure to put on the main queue to update UI!
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Everyday iOS app: activationDidCompleteWith: activationState: error")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Everyday iOS app: sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Everyday iOS app: sessionDidDeactivate")
    }
}
