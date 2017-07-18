//
//  CallHistory.swift
//  Kertel
//
//  Created by Kertel on 25/04/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation

struct CallHistory : CallFormatter {
    let isIncoming: Bool
    let isSeen: Bool
    let callId: String
    let name: String?
    let state: String
    let number: String?
    let duration: TimeInterval
    let date: Date
    var infoCall : [(title: String, value: String)] = []
    
    init(callId: String, name: String?, number: String?, state: String, duration: TimeInterval, date: Date, isIncoming: Bool, isSeen: Bool) {
        self.name = name
        self.callId = callId
        self.state = state
        self.duration = duration
        self.date = date
        self.number = number
        self.isIncoming = isIncoming
        self.isSeen = isSeen
        fillInfoCall()
    }
    
    func getPresentationName() -> String!
    {
        if name != nil && !(name?.isEmpty)!
        {
            return name
        }
        else if number != nil && !(number?.isEmpty)!
        {
            return number
        }
        else
        {
            return "Numéro inconnue"
        }
    }
    
    /*func getFormateNumber() -> String!
     {
     
     }
     */
    
    func isMissed() -> Bool
    {
        if state == "noanswer"
        {
            return true
        }
        return false
    }
    
    func getState() -> String!
    {
        switch (state)
        {
        case "busy":
            return ("Occupé");
        case "noanswer":
            return ("Appel manqué");
        case "noroute":
            return ("Non routé");
        case "pickup":
            return ("Intercepté");
        case "divert":
            return ("Renvoyé");
        case "connected":
            return ("Conversation");
        case "error":
            return ("Non routé");
        default:
            return ("");
        }
    }
    
   
    
    func getStateSmart() -> String!
    {
        switch (state)
        {
        case "busy":
            return ("Occupé");
        case "noanswer":
            if isIncoming
            {
                return ("Appel manqué");
            }
            return ("Sans réponse");
        case "noroute":
            return ("Non routé");
        case "pickup":
            return ("Intercepté");
        case "divert":
            return ("Renvoyé");
        case "connected":
            if isIncoming
            {
                return ("Appel entrant");
            }
            return ("Appel sortant");
        case "error":
            return ("Non routé");
        default:
            return ("");
        }
    }
    
    mutating func fillInfoCall()
    {
        infoCall.append(("Date", getDate()))
        infoCall.append(("Numéro", number!))
        infoCall.append(("Durée", getDuration()))
        infoCall.append(("État", getState()))
    }
    
}
