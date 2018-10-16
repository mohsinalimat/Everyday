//
//  InterfaceController.swift
//  Meets Extension
//
//  Created by Hemang on 11/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import WatchKit

class MeetListInterfaceController: WKInterfaceController {

    @IBOutlet private weak var tableRowController: WKInterfaceTable!
    
    private var meets = [Meets]()
    private var colors = [UIColor.cyan, UIColor.purple, UIColor.yellow, UIColor.red.withAlphaComponent(0.5), UIColor.orange, UIColor.blue, UIColor.green, UIColor.magenta]

    //MARK: View Life Cycle
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        if let requestedMeets = context as? [Meets], !requestedMeets.isEmpty {
            setTitle("List [\(requestedMeets.count)]")
            meets.append(contentsOf: requestedMeets)
            tableRowController.setNumberOfRows(meets.count, withRowType: Constants.TableRow.Identifiers.MeetList)
            for (index, meet) in meets.enumerated() {
                if let row = tableRowController.rowController(at: index) as? MeetsRowController {
                    //Uncomment and this will show random color for the left edge.
                    //let color = colors.randomElement() ?? UIColor.black.withAlphaComponent(0.5)
                    //row.config(leftEdgeColor: color, unreadCircleColor: color)
                    row.meet = meet
                    row.isRead = meet.isRead
                }
            }
        } else {
            setTitle("")
            tableRowController.setNumberOfRows(1, withRowType: Constants.TableRow.Identifiers.MeetList)
            let row = tableRowController.rowController(at: 0) as? MeetsRowController
            row?.configNoSchedules()
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        guard !meets.isEmpty else { return nil }
        let row = table.rowController(at: rowIndex) as? MeetsRowController
        row?.isRead = true        
        return meets[rowIndex]
    }
    
    //MARK: Actions
    @IBAction func actionLongPress() {
        popToRootController()
    }
}
