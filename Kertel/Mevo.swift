//
//  Mevo.swift
//  Kertel
//
//  Created by Kertel on 10/07/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation

class Mevo {
    let id: String
    let date: Date
    let number: String?
    let duration: TimeInterval
    let isSeen: Bool
    
    init(id: String, number: String?, duration: TimeInterval, date: Date, isSeen: Bool) {
        self.id = id
        self.duration = duration
        self.date = date
        self.number = number
        self.isSeen = isSeen
    }
    
}
