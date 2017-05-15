//
//  CallHistory.swift
//  Kertel
//
//  Created by Kertel on 25/04/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation

struct CallHistory {
    let callId: String?
    let name: String
    let state: String?
    let number: String?
    let duration: DateInterval?
    let date: Date?
    
    init(name: String, number : String) {
        self.name = name
        self.callId = nil
        self.state = nil
        self.duration = nil
        self.date = nil
        self.number = number
    }
}
