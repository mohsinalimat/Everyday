//
//  MeetDetailsInterfaceController.swift
//  Meets Extension
//
//  Created by Hemang on 11/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import WatchKit

class MeetDetailsInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var labelDetails: WKInterfaceLabel!
    
    @IBOutlet weak var btnCall: WKInterfaceButton!
    @IBOutlet weak var btnDirection: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let meet = context as? Meets {
            meet.read()
            labelDetails.setAttributedText(meet.fullInfo)
            
            if meet.actionType == .call {
                btnCall.setHidden(false)
            } else if meet.actionType == .direction {
                btnDirection.setHidden(false)
            }
        } else {
            setTitle("")
            labelDetails.setAttributedText(NSAttributedString.init(string: "Really, nothing to do!\nEnjoy 🍿", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor: UIColor.white]))
        }
    }

    @IBAction func actionLongPress() {
        popToRootController()
    }
}
