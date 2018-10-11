//
//  Meets.swift
//  Meets Extension
//
//  Created by Hemang on 11/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import UIKit

class Meets {
    
    var title: String?
    var details: String?
    var startTime: Date?
    var endTime: Date?
    var actionType: MeetActionType = .other
    var onDay: MeetOnDay = .other
    var meetHours: MeetHours = .fixed
    
    enum MeetActionType {
        case call, direction, other
    }
    
    enum MeetOnDay {
        case yesterday, today, tomorrow, other
    }
    
    enum MeetHours {
        case fixed, fullday
    }
    
    private(set) var isRead: Bool = false
    
    private(set) var partialInfo: NSMutableAttributedString?
    private(set) var fullInfo: NSMutableAttributedString?
    
    func create() {
        
        //reset
        partialInfo = NSMutableAttributedString()
        fullInfo = NSMutableAttributedString()
        
        if let title = title {
            //Meet Title
            let titleAttributed = NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15.0)])
            partialInfo?.append(titleAttributed)
            
            //Meet Date + Time + Fullday + Today/Tomorrow/Yesterday
            if let startTime = startTime {
                let df = DateFormatter()
                
                //Yesterday, Today, Tomorrow, or other date.
                let dateAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10.0)]
                var dateAttributed: NSAttributedString?
                if startTime.isToday() {
                    onDay = .today
                    dateAttributed = NSAttributedString.init(string: "Today", attributes: dateAttributes)
                } else if startTime.isYesterday() {
                    onDay = .yesterday
                    dateAttributed = NSAttributedString.init(string: "Yesterday", attributes: dateAttributes)
                } else if startTime.isTomorrow() {
                    onDay = .tomorrow
                    dateAttributed = NSAttributedString.init(string: "Tomorrow", attributes: dateAttributes)
                } else {
                    onDay = .other
                    df.dateFormat = "MMM dd, yyyy"
                    let date = df.string(from: startTime)
                    dateAttributed = NSAttributedString.init(string: date, attributes: dateAttributes)
                }
                if let dateAttributed = dateAttributed {
                    partialInfo?.append(NSAttributedString.init(string: "\n"))
                    partialInfo?.append(dateAttributed)
                    fullInfo?.append(dateAttributed)
                }

                //Start Time
                df.dateFormat = "hh:mm a"
                let from = df.string(from: startTime)
                let fromAttributed = NSAttributedString.init(string: "\n" + from, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10.0)])
                partialInfo?.append(fromAttributed)
                fullInfo?.append(fromAttributed)
                
                //End Time
                if let endTime = endTime {
                    let to = df.string(from: endTime)
                    
                    //Fullday Check
                    let toAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10.0)]
                    let diff = endTime.hours(from: startTime)
                    if diff >= 8 {
                        meetHours = .fullday
                        let toAttributed = NSAttributedString.init(string: " - Fullday", attributes: toAttributes)
                        partialInfo?.append(toAttributed)
                        fullInfo?.append(toAttributed)
                    } else {
                        meetHours = .fixed
                        let toAttributed = NSAttributedString.init(string: " - " + to, attributes: toAttributes)
                        partialInfo?.append(toAttributed)
                        fullInfo?.append(toAttributed)
                    }
                }
            }
            
            fullInfo?.append(NSAttributedString.init(string: "\n\n"))
            fullInfo?.append(titleAttributed)
            
            //Meet Details
            if let details = details {
                let detailAttributed = NSAttributedString.init(string: "\n\n" + details, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)])
                fullInfo?.append(detailAttributed)
            }
            
        }
    }
    
    func read() {
        isRead = true
    }
}
