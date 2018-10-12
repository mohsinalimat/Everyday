//
//  MeetOptionsInterfaceController.swift
//  Meets Extension
//
//  Created by Hemang on 11/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import WatchKit

class MeetOptionsInterfaceController: WKInterfaceController {

    private var meets = [Meets]()
    private let currentCalendar = Calendar.current
    
    //MARK: View Life Cycle
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setupMeets()
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
    
    //Setup Data
    private func setupMeets() {
        let today = Date()
        
        let todayInt = currentCalendar.component(.day, from: today)
        let yesterdayInt = currentCalendar.component(.day, from: today.yesterday)
        let tomorrowInt = currentCalendar.component(.day, from: today.tomorrow)
        
        let m0 = Meets()
        m0.title = "Standup Meeting"
        m0.details = "To discuss Lucky Spoon Project."
        m0.startTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: yesterdayInt, hour: 9, minute: 0).date
        m0.endTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: yesterdayInt, hour: 10, minute: 0).date
        m0.actionType = .call
        m0.read()
        meets.append(m0)
        
        let m1 = Meets()
        m1.title = "Meeting with Boss"
        m1.details = "To discuss for upcoming projects."
        m1.startTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: todayInt, hour: 9, minute: 0).date
        m1.endTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: todayInt, hour: 10, minute: 0).date
        meets.append(m1)
        
        let m2 = Meets()
        m2.title = "Interview - Telephonic"
        m2.details = "Call Mr. Ravi for iOS (Jr) - +91-XXX-XXX-XXXX"
        m2.startTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: todayInt, hour: 10, minute: 15).date
        m2.endTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: todayInt, hour: 11, minute: 0).date
        m2.actionType = .call
        meets.append(m2)
        
        let m3 = Meets()
        m3.title = "Interview - Telephonice"
        m3.details = "Call Mr. Jatin for iOS (Sr) - +91-XXX-XXX-XXXX"
        m3.startTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: todayInt, hour: 11, minute: 15).date
        m3.endTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: todayInt, hour: 12, minute: 0).date
        m3.actionType = .call
        meets.append(m3)
        
        let m4 = Meets()
        m4.title = "Branch Visit"
        m4.details = "Visit Manayata Tech Park Branch."
        m4.startTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: todayInt, hour: 13, minute: 0).date
        m4.endTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: todayInt, hour: 15, minute: 0).date
        m4.actionType = .direction
        meets.append(m4)
        
        let m5 = Meets()
        m5.title = "Call Alex"
        m5.details = "Lucky Spoon Project Features Implementations."
        m5.startTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: todayInt, hour: 16, minute: 0).date
        m5.endTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: todayInt, hour: 19, minute: 0).date
        m5.actionType = .call
        meets.append(m5)
        
        let m6 = Meets()
        m6.title = "Client Visit"
        m6.details = "Visit to XYZ Co. in Whitefield.\nLandmark: Next to IBM Campus\n\nContact Person: Mr. G. Ravi\n\nContact: XX-XX-XXX-XXX"
        m6.startTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: tomorrowInt, hour: 9, minute: 0).date
        m6.endTime = DateComponents.init(calendar: currentCalendar, year: 2018, month: 10, day: tomorrowInt, hour: 19, minute: 0).date
        m6.actionType = .call
        meets.append(m6)
        
        _ = meets.map {$0.create()}
    }
}
