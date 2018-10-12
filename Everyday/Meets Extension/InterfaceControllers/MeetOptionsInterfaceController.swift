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
        actionGetMeetsAPICall()
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
    
    private func actionGetMeetsAPICall() {
        if let url = URL(string: "https://demo8026454.mockable.io/allmeets") {
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            let session = URLSession.init(configuration: config)
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("API Error: ", error.localizedDescription)
                } else {
                    do {
                        let jsonArray = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [[String : Any]]
                        let meetsArray = jsonArray.map {Meets.init(dictionary: $0)}
                        self?.meets.append(contentsOf: meetsArray)
                    } catch let error {
                        print("JSON Parsing Error: ", error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
}
