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
    
    private var meets = [Meets]()
    private let currentCalendar = Calendar.current
    
    //MARK: View Life Cycle
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == Constants.InterfaceController.Identifiers.MeetList.Today {
            return meets.filter {$0.onDay == .today}
        } else if segueIdentifier == Constants.InterfaceController.Identifiers.MeetList.Tomorrow {
            return meets.filter {$0.onDay == .tomorrow}
        } else {
            return meets
        }
    }
    
    //MARK: Actions
    @IBAction func actionGetMeets() {
        
    }
    
    //MARK: Helpers
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
