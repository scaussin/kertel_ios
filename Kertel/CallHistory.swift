//
//  CallHistory.swift
//  Kertel
//
//  Created by Kertel on 25/04/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation

struct CallHistory {
    let isIncoming: Bool
    let callId: String
    let name: String
    let state: String
    let number: String
    let duration: DateInterval
    let date: Date
    
    init(callId: String, name: String, number: String, state: String, duration: DateInterval, date: Date, isIncoming: Bool) {
        self.name = name
        self.callId = callId
        self.state = state
        self.duration = duration
        self.date = date
        self.number = number
        self.isIncoming = isIncoming
    }
}
