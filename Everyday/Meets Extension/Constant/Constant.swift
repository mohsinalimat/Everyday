//
//  Constant.swift
//  Meets Extension
//
//  Created by Hemang on 12/10/18.
//  Copyright © 2018 Hemang Shah. All rights reserved.
//

import Foundation

struct Constants {
    struct InterfaceController {
        struct Identifiers {
            struct MeetList {
                static let Today = "MeetListTodayIdentifier"
                static let Tomorrow = "MeetListTomorrowIdentifier"
            }
        }
    }
    
    struct TableRow {
        struct Identifiers {
            static let MeetList = "MeetsRowControllerIdentifier"
        }
    }
    
    struct Meet {
        struct Titles {
            static let NoScheduleForList = "You're a free bird!🏄🏽‍♂️\nNo meetings scheduled."
            static let NoScheduleForDetails = "Really, nothing to do!\nEnjoy 🍿"
            static let Fullday = "Fullday"
            
            struct OnDay {
                static let Yesterday = "Yesterday"
                static let Today = "Today"
                static let Tomorrow = "Tomorrow"
            }
        }
        
        struct DateTime {
            static let dateFormat = "MMM dd, yyyy"
            static let timeFormat = "hh:mm a"
        }
    }
}
