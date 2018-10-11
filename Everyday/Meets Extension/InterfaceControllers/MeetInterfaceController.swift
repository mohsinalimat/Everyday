//
//  InterfaceController.swift
//  Meets Extension
//
//  Created by Hemang on 11/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import WatchKit

class MeetListInterfaceController: WKInterfaceController {

    @IBOutlet weak var tableRowController: WKInterfaceTable!
    
    private var meets = [Meets]()
    private var colors = [UIColor.cyan, UIColor.purple, UIColor.yellow, UIColor.red.withAlphaComponent(0.5), UIColor.orange, UIColor.blue, UIColor.green, UIColor.magenta]

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if let requestedMeets = context as? [Meets], !requestedMeets.isEmpty {
            setTitle("List [\(requestedMeets.count)]")
            meets.append(contentsOf: requestedMeets)
            tableRowController.setNumberOfRows(meets.count, withRowType: "MeetsRowControllerIdentifier")
            for (index, meet) in meets.enumerated() {
                if let row = tableRowController.rowController(at: index) as? MeetsRowController {
                    row.labelInfo.setAttributedText(meet.partialInfo)
                    row.isRead = meet.isRead
                    let color = colors.randomElement() ?? UIColor.black.withAlphaComponent(0.5)
                    row.groupColoredLeftEdge.setBackgroundColor(color)
                    row.groupUnreadCircle.setBackgroundColor(color)
                }
            }
        } else {
            setTitle("")
            tableRowController.setNumberOfRows(1, withRowType: "MeetsRowControllerIdentifier")
            let row = tableRowController.rowController(at: 0) as? MeetsRowController
            row?.labelInfo.setAttributedText(NSAttributedString.init(string: "You're a free bird!🏄🏽‍♂️\nNo meetings scheduled.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor: UIColor.white]))
            row?.groupColoredLeftEdge.setHidden(true)
            row?.groupUnreadCircle.setHidden(true)
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        guard !meets.isEmpty else { return nil }
        let row = table.rowController(at: rowIndex) as? MeetsRowController
        row?.isRead = true        
        return meets[rowIndex]
    }
    
    @IBAction func actionLongPress() {
        popToRootController()
    }
}
