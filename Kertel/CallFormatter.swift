//
//  formater.swift
//  Kertel
//
//  Created by Kertel on 18/07/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation

extension CallFormatter
{
    func getNumber() -> String!
    {
        return (number)
    }
    
    func getDate() -> String!
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMM yyyy à HH:mm:ss"
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
    
    func getShortDuration() -> String!
    {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "fr")
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        formatter.calendar = calendar
        formatter.unitsStyle = .positional
        /*
         .abbreviated    2m 13s
         .brief          2min 13sec
         .full           2 minutes, 13 secondes
         .positional     2:13
         .short          2 min, 13 sec
         */
        
        return formatter.string(from: duration)!
    }
    
}

protocol CallFormatter {
    var number: String? { get }
    var duration: TimeInterval { get }
    var date: Date { get }
}

