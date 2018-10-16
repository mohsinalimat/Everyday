//
//  MeetOptionsInterfaceController.swift
//  Meets Extension
//
//  Created by Hemang on 11/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import WatchKit

class MeetOptionsInterfaceController: WKInterfaceController {
    
    @IBOutlet private weak var labelLoading: WKInterfaceLabel!
    @IBOutlet private weak var btnTryAgain: WKInterfaceButton!
    
    @IBOutlet private weak var groupOptions: WKInterfaceGroup!
    @IBOutlet private weak var groupLoading: WKInterfaceGroup!
    
    private var meetings = [Meeting]()
    private let currentCalendar = Calendar.current
    
    //MARK:- View Life Cycle
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.handleWatchSessionManagerCallbacks()
    }
    
    //MARK:- Handle WatchSessionManager Callbacks
    fileprivate func handleWatchSessionManagerCallbacks() {
        WatchSessionManager.sharedManager.onSessionRechableStateChange = { rechable in
            if rechable {
                print("WatchOS app is connected with the iOS app.")
            } else {
                print("WatchOS app is not connected with the iOS app.")
            }
        }
        
        WatchSessionManager.sharedManager.onSessionStateChange = { [weak self] sessionState, error in
            switch sessionState {
            case .activated:
                print("WatchOS app session activated.")
                self?.actionGetMeets()
            case .notActivated:
                print("WatchOS app session notActivated.")
            case .inactive:
                print("WatchOS app session is inactive.")
            case .deactivate:
                print("WatchOS app session is deactivated.")
            }
            if let error = error {
                print("WatchOS app session change error: \(error.localizedDescription)")
            }
        }
        
        WatchSessionManager.sharedManager.onSessionRequest = { success, error in
            if success {
                print("WatchOS app sent request to the iOS app.")
            } else {
                if let error = error {
                    print("WatchOS app couldn't send request to the iOS app. Error: \(error.localizedDescription)")
                } else {
                    print("WatchOS app couldn't send request to the iOS app.")
                }
            }
        }
        
        WatchSessionManager.sharedManager.onReceivingMessage = { [weak self] message in
            if let allMeetings = message["meetings"] as? [[String: String]] {
                self?.setupSuccess()
                self?.meetings.removeAll()
                self?.meetings.append(contentsOf: allMeetings.map { Meeting.init(dictionary: $0) })
            }
        }
    }
    
    //MARK:- Handling Segue
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == Constants.InterfaceController.Identifiers.MeetList.Today {
            return meetings.filter {$0.onDay == .today}
        } else if segueIdentifier == Constants.InterfaceController.Identifiers.MeetList.Tomorrow {
            return meetings.filter {$0.onDay == .tomorrow}
        } else {
            return meetings
        }
    }
    
    //MARK:- Actions
    @IBAction func actionGetMeets() {
        WatchSessionManager.sharedManager.send(message: ["fetch": true])
    }
    
    //MARK:- UI Helpers
    private func setupAPICallUI() {
        groupOptions.setHidden(true)
        groupLoading.setHidden(false)
        btnTryAgain.setHidden(true)
        labelLoading.setText(Constants.InterfaceController.APICalls.Loading)
    }
    
    private func setupTryAgain() {
        labelLoading.setText(Constants.InterfaceController.APICalls.TryAgain)
        btnTryAgain.setHidden(false)
    }
    
    private func setupSuccess() {
        groupLoading.setHidden(true)
        groupOptions.setHidden(false)
    }
}
