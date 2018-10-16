//
//  WatchSessionManager.swift
//  Everyday
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
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    private var validSession: WCSession? {
        
        // paired - the user has to have their device paired to the watch
        // watchAppInstalled - the user must have your watch app installed
        
        // Note: if the device is paired, but your watch app is not installed
        // consider prompting the user to install it for a better experience
        
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
    }
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
}

// MARK: Application Context
extension WatchSessionManager {
    
    // Sender
    func updateApplicationContext(applicationContext: [String : Any]) throws {
        print("Everyday iOS app: updateApplicationContext:")
        if let session = validSession {
            do {
                try session.updateApplicationContext(applicationContext)
            } catch let error {
                throw error
            }
        }
    }
    
    // Receiver
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
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
