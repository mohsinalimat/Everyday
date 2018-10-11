//
//  MeetsRowController.swift
//  Meets Extension
//
//  Created by Hemang on 11/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import WatchKit

class MeetsRowController: NSObject {
    
    @IBOutlet var labelInfo: WKInterfaceLabel!
    @IBOutlet var groupColoredLeftEdge: WKInterfaceGroup!
    @IBOutlet var groupUnreadCircle: WKInterfaceGroup!
    
    var meet: Meets! {
        didSet {
            labelInfo.setAttributedText(meet.partialInfo)
        }
    }
    
    var isRead: Bool = false {
        didSet {
            groupUnreadCircle.setAlpha(isRead ? 0.0 : 1.0)
        }
    }
}
