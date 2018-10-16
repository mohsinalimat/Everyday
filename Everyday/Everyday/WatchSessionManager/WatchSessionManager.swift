//
//  WatchSessionManager.swift
//  Everyday
//
//  Created by Hemang on 16/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import UIKit
import WatchConnectivity

enum SessionState {
    case activated, notActivated, inactive, deactivate
}

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let sharedManager = WatchSessionManager()
    
    var onSessionStateChange: ((_ state: SessionState, _ error: Error?) -> Void)?
    var onSessionRechableStateChange: ((_ isReachable: Bool) -> Void)?
    var onSessionRequest:((_ success: Bool, _ error: Error?) -> Void)?
    var onReceivingApplicationContext:((_ applicationContext: [String : Any]) -> Void)?
    var onReceivingMessage:((_ message: [String : Any]) -> Void)?
    
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

// MARK:- Application Context
extension WatchSessionManager {
    func updateApplicationContext(applicationContext: [String : Any]) throws {
        if let session = validSession {
            do {
                try session.updateApplicationContext(applicationContext)
                onSessionRequest?(true, nil)
            } catch let error {
                onSessionRequest?(false, error)
                throw error
            }
        }
    }
    
    func send(message: [String: Any]) {
        if let session = validSession {
            session.sendMessage(message, replyHandler: nil) { [weak self] (error) in
                self?.onSessionRequest?(false, error)
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        onReceivingApplicationContext?(applicationContext)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        onReceivingMessage?(message)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            onSessionStateChange?(.activated, error)
        } else if activationState == .inactive {
            onSessionStateChange?(.inactive, error)
        } else if activationState == .notActivated {
            onSessionStateChange?(.notActivated, error)
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        onSessionRechableStateChange?(session.isReachable)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        onSessionStateChange?(.inactive, nil)
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        onSessionStateChange?(.deactivate, nil)
    }
}
