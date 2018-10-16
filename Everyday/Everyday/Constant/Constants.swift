//
//  Constants.swift
//  Everyday
//
//  Created by Hemang on 16/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import Foundation

struct Constants {    
    struct Request {
        static let EndPoint = "https://demo8026454.mockable.io/allmeets"
    }
    
    struct ResponseKeys {
        struct Meet {
            static let Title = "title"
            static let Details = "details"
            static let StartTime = "startTime"
            static let EndTime = "endTime"
            static let Action = "action"
        }
        struct MeetActions {
            static let Call = "call"
            static let Direction = "direction"
        }
    }    
}
