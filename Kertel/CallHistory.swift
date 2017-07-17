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
    
    func getDate() -> String!
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMM yyyy  HH:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "fr_FR")
        
        return (dateFormatter.string(from: date))
    }
    
    func getDuration() -> String!
    {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "fr")
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        //formatter.zeroFormattingBehavior = .pad
        formatter.calendar = calendar
        formatter.unitsStyle = .full
        /*
         .abbreviated    2m 13s
         .brief          2min 13sec
         .full           2 minutes, 13 secondes
         .positional     2:13
         .short          2 min, 13 sec
        */
        
        return formatter.string(from: duration)!
    }
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
    
    func getShortDate() -> String!
    {
        let dateFormatter = DateFormatter()
        let currDate = Date()
        
        dateFormatter.dateFormat = "ddMMyyyy"
        dateFormatter.locale = Locale.init(identifier: "fr_FR")
        let dateCmp = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "ddMMyyyy"
        let currDateCmp = dateFormatter.string(from: currDate)
        
        if (currDateCmp == dateCmp)
        {
            dateFormatter.dateFormat = "HH:mm"
        }
        else
        {
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }
        return (dateFormatter.string(from: date))
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
