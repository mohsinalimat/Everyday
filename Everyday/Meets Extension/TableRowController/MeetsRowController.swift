//
//  MeetsRowController.swift
//  Meets Extension
//
//  Created by Hemang on 11/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import WatchKit

class MeetsRowController: NSObject {
    
    @IBOutlet private var labelInfo: WKInterfaceLabel!
    @IBOutlet private var groupColoredLeftEdge: WKInterfaceGroup!
    @IBOutlet private var groupUnreadCircle: WKInterfaceGroup!
    
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
    
    func config(leftEdgeColor color: UIColor, unreadCircleColor: UIColor) {
        groupColoredLeftEdge.setBackgroundColor(color)
        groupUnreadCircle.setBackgroundColor(unreadCircleColor)
    }
    
    func configNoSchedules() {
        labelInfo.setAttributedText(NSAttributedString.init(string: "You're a free bird!🏄🏽‍♂️\nNo meetings scheduled.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor: UIColor.white]))
        hideLeftEdge()
        hideUnreadCircle()
    }
    
    private func hideLeftEdge() {
        groupColoredLeftEdge.setHidden(true)
    }
    
    private func hideUnreadCircle() {
        groupUnreadCircle.setHidden(true)
    }
}
