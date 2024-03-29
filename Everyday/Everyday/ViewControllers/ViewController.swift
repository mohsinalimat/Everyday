//
//  ViewController.swift
//  Everyday
//
//  Created by Hemang on 11/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    fileprivate let apd = UIApplication.shared.delegate as! AppDelegate
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleWatchSessionManagerCallbacks()
        self.actionFetchTodoListAPI()
    }
    
    //MARK:- Handler WatchSessionManager Callbacks
    fileprivate func handleWatchSessionManagerCallbacks() {
        WatchSessionManager.sharedManager.onSessionRechableStateChange = { rechable in
            if rechable {
                print("iOS app is connected with the WatchOS app.")
            } else {
                print("iOS app is not connected with the WatchOS app.")
            }
        }
        
        WatchSessionManager.sharedManager.onSessionStateChange = { [weak self] sessionState, error in
            switch sessionState {
            case .activated:
                print("iOS app session activated.")
                self?.sendToWatchApp()
            case .notActivated:
                print("iOS app session notActivated.")
            case .inactive:
                print("iOS app session is inactive.")
            case .deactivate:
                print("iOS app session is deactivated.")
            }
            if let error = error {
                print("iOS app session change error: \(error.localizedDescription)")
            }
        }
        
        WatchSessionManager.sharedManager.onSessionRequest = { success, error in
            if success {
                print("iOS app sent request to the WatchOS app.")
            } else {
                if let error = error {
                    print("iOS app couldn't send request to the WatchOS app. Error: \(error.localizedDescription)")
                } else {
                    print("iOS app couldn't send request to the WatchOS app.")
                }
            }
        }
        
        WatchSessionManager.sharedManager.onReceivingMessage = { [weak self] applicationContext in
            DispatchQueue.main.async {
                if let fetch = applicationContext["fetch"] as? Bool, fetch {
                    self?.sendToWatchApp()
                } else {
                    print("iOS app Data Received: Handle other requests.\n\(applicationContext)")
                }
            }
        }
    }
    
    //MARK:- Send To Watch
    fileprivate func sendToWatchApp() {
        self.fetchMeetings { [weak self] (meetings) in
            guard let meetings = meetings else { return }
            if let allMeetings = self?.convertToDictionaryArray(from: meetings) {
                print("All meetings count: ", allMeetings.count)
                WatchSessionManager.sharedManager.send(message: ["meetings": allMeetings])
            }
        }
    }
    
    fileprivate func convertToDictionaryArray(from managedObjects: [NSManagedObject]) -> [[String: Any]] {
        var result: [[String: Any]] = []
        for meeting in managedObjects {
            var dict: [String: Any] = [:]
            for attribute in meeting.entity.attributesByName {
                if let value = meeting.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            result.append(dict)
        }
        return result
    }
    
    //MARK:- Manage Meetings
    fileprivate func deleteExistingMeetings(completion: @escaping(_ returned: Bool) ->()) {
        let fetchMeetingsRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Meeting")
        fetchMeetingsRequest.includesPropertyValues = false
        let context = apd.persistentContainer.viewContext
        do {
            let results = try context.fetch(fetchMeetingsRequest) as! [NSManagedObject]
            for result in results {
                context.delete(result)
            }
            try context.save()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    fileprivate func fetchMeetings(completion: (([Meeting]?)->Void)) {
        let fetchMeetingsRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Meeting")
        fetchMeetingsRequest.sortDescriptors = [NSSortDescriptor.init(key: "startTime", ascending: true)]
        fetchMeetingsRequest.returnsObjectsAsFaults = false
        fetchMeetingsRequest.returnsDistinctResults = true
        let context = apd.persistentContainer.viewContext
        do {
            let meetings = try context.fetch(fetchMeetingsRequest)
            if let meetings = meetings as? [Meeting] {
                completion(meetings)
            } else {
                completion(nil)
            }
        } catch let error {
            print("Error in fetching saved meetings: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    //MARK:- Save to Core Data
    fileprivate func saveMeeting(dictionary: [String: String]) {
        let context = apd.persistentContainer.viewContext
        if let meetingEntity = NSEntityDescription.entity(forEntityName: "Meeting", in: context) {
            let meeting = Meeting.init(entity: meetingEntity, insertInto: context)
            meeting.title = dictionary[Constants.ResponseKeys.Meet.Title]
            meeting.details = dictionary[Constants.ResponseKeys.Meet.Details]
            meeting.startTime = dictionary[Constants.ResponseKeys.Meet.StartTime]
            meeting.endTime = dictionary[Constants.ResponseKeys.Meet.EndTime]
            meeting.action = dictionary[Constants.ResponseKeys.Meet.Action]
            do {
                try context.save()
            } catch let error {
                print("Error saving meeting record: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK:- API Request
    fileprivate func actionFetchTodoListAPI() {
        if let url = URL(string: Constants.Request.EndPoint) {
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            let session = URLSession.init(configuration: config)
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                guard let data = data else { return }
                self?.deleteExistingMeetings(completion: { (deleted) in
                    DispatchQueue.main.async {
                        do {
                            let jsonArray = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [[String : String]]
                            _ = jsonArray.map { self?.saveMeeting(dictionary: $0) }
                        } catch let error {
                            print("JSON Parsing Error: ", error.localizedDescription)
                        }
                    }
                })
            }
            task.resume()
        }
    }
}
