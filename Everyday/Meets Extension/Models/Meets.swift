//
//  Meets.swift
//  Meets Extension
//
//  Created by Hemang on 11/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import UIKit

class Meets {
    
    ///Meeting Title.
    var title: String?
    ///Meeting Details.
    var details: String?
    ///Meeting Start Time.
    var startTime: Date?
    ///Meeting End Time.
    var endTime: Date?
    ///Helpful to display different action buttons in Meeting Details Interface Controller.
    var actionType: MeetActionType = .other
    ///Helpful to check to whether date is yesterday/today/tomorrow or other.
    private(set) var onDay: MeetOnDay = .other
    ///Helpful to check the meeting duration.
    private(set) var meetHours: MeetHours = .fixed
    ///Helpful to check whether a meeting is read or not. Default: false
    private(set) var isRead: Bool = false
    ///Helpful to set meeting information in Meet Interface Controller.
    private(set) var partialInfo: NSMutableAttributedString?
    ///Helpful to set meeting information in Meet Details Interface Controller.
    private(set) var fullInfo: NSMutableAttributedString?
    
    ///Various Action Types, like: Call or Direction. Default: .other
    enum MeetActionType {
        case call, direction, other
    }
    
    ///Various Day Types, like: Yesterday/Today/Tomorrow. Default: .other
    enum MeetOnDay {
        case yesterday, today, tomorrow, other
    }
    
    ///Various Meeting Hours, like: Fixed/Fullday. Default: .fixed
    enum MeetHours {
        case fixed, fullday
    }
    
    init(dictionary: [String: Any?]) {
        title = dictionary[Constants.ResponseKeys.Meet.Title] as? String
        details = dictionary[Constants.ResponseKeys.Meet.Details] as? String
        actionType = getActionType(from: dictionary[Constants.ResponseKeys.Meet.Action] as? String)
        
        if let startTime = dictionary[Constants.ResponseKeys.Meet.StartTime] as? String {
            self.startTime = getDate(fromDate: startTime)
        }
        if let endTime = dictionary[Constants.ResponseKeys.Meet.EndTime] as? String {
            self.endTime = getDate(fromDate: endTime)
        }
        
        create()
    }
    
    private func getDate(fromDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.date(from: fromDate)
    }
    
    private func getActionType(from: String?) -> MeetActionType {
        guard let from = from else { return .other }
        if from == "call" { return .call }
        if from == "direction" { return .direction }
        else { return .other }
    }
    
    private func create() {
        
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
                    dateAttributed = NSAttributedString.init(string: Constants.Meet.Titles.OnDay.Today, attributes: dateAttributes)
                } else if startTime.isYesterday() {
                    onDay = .yesterday
                    dateAttributed = NSAttributedString.init(string: Constants.Meet.Titles.OnDay.Yesterday, attributes: dateAttributes)
                } else if startTime.isTomorrow() {
                    onDay = .tomorrow
                    dateAttributed = NSAttributedString.init(string: Constants.Meet.Titles.OnDay.Tomorrow, attributes: dateAttributes)
                } else {
                    onDay = .other
                    df.dateFormat = Constants.Meet.DateTime.dateFormat
                    let date = df.string(from: startTime)
                    dateAttributed = NSAttributedString.init(string: date, attributes: dateAttributes)
                }
                if let dateAttributed = dateAttributed {
                    partialInfo?.append(NSAttributedString.init(string: "\n"))
                    partialInfo?.append(dateAttributed)
                    fullInfo?.append(dateAttributed)
                }

                //Start Time
                df.dateFormat = Constants.Meet.DateTime.timeFormat
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
                        let toAttributed = NSAttributedString.init(string: " - " + Constants.Meet.Titles.Fullday, attributes: toAttributes)
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
    
    ///Helper to set a meeting as Read.
    func read() {
        isRead = true
    }
    
    ///Helper to set a meeting as Unread.
    func unread() {
        isRead = false
    }
}
