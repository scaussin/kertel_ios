//
//  Forward.swift
//  Kertel
//
//  Created by Kertel on 08/09/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation

public class Forward {
    public var usr : Usr?
    public var na : Na?
    public var busy : Busy?
    
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["usr"] != nil) { usr = Usr(dictionary: dictionary["usr"] as! NSDictionary) }
        if (dictionary["na"] != nil) { na = Na(dictionary: dictionary["na"] as! NSDictionary) }
        if (dictionary["busy"] != nil) { busy = Busy(dictionary: dictionary["busy"] as! NSDictionary) }
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.usr?.dictionaryRepresentation(), forKey: "usr")
        dictionary.setValue(self.na?.dictionaryRepresentation(), forKey: "na")
        dictionary.setValue(self.busy?.dictionaryRepresentation(), forKey: "busy")
        
        return dictionary
    }
}

public class SimpleForward {
    var transfertTo : TypeChoice?
    var data : String?
    var timeout : Int?
}

func getSimpleForward(forwards : Array<Forwards>?) -> SimpleForward {
    let simpleForward = SimpleForward()
    
    if forwards != nil &&
        forwards?.count == 1 &&
        forwards?[0] != nil &&
        forwards?[0].filters == nil &&
        forwards?[0].dests != nil &&
        forwards?[0].dests?.count == 1 &&
        forwards?[0].dests?[0] != nil &&
        forwards?[0].dests?[0].entity != nil
    {
        let typeForward : TypeChoice! = forwards?[0].dests?[0].entity?.getTypeChoice()
        
        if (typeForward == TypeChoice.Phone && (forwards?[0].dests?[0].entity?.data == nil) || (forwards?[0].dests?[0].entity?.data?.isEmpty)!) {
            simpleForward.transfertTo = TypeChoice.Phone
        }
        else if (typeForward == TypeChoice.Mevo && forwards?[0].dests?[0].entity?.data != nil && forwards?[0].dests?[0].entity?.data == "DEFAULT") {
            simpleForward.transfertTo = TypeChoice.Mevo
        }
        else if (typeForward == TypeChoice.Mobile && forwards?[0].dests?[0].entity?.dataObj != nil && forwards?[0].dests?[0].entity?.dataObj?.dest != nil && forwards?[0].dests?[0].entity?.dataObj?.dest == "GSM" && forwards?[0].dests?[0].entity?.dataObj?.id != nil && (forwards?[0].dests?[0].entity?.dataObj?.id?.isEmpty)!) {
            simpleForward.transfertTo = TypeChoice.Mobile
        }
        else if (typeForward == TypeChoice.CustomNumber && !(forwards?[0].dests?[0].entity?.data?.isEmpty)!) {
            simpleForward.transfertTo = TypeChoice.CustomNumber
            simpleForward.data = forwards?[0].dests?[0].entity?.data
        }
        if forwards?[0].dests?[0].timeout != nil {
            simpleForward.timeout = forwards?[0].dests?[0].timeout
        }
        return simpleForward
    }
    simpleForward.transfertTo = TypeChoice.Other
    return simpleForward
}

public class Usr {
    public var id : Int?
    public var forwards : Array<Forwards>?
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        if (dictionary["forwards"] != nil) { forwards = Forwards.modelsFromDictionaryArray(array: dictionary["forwards"] as! NSArray) }
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        
        return dictionary
    }
}

public class Na {
    public var id : Int?
    public var forwards : Array<Forwards>?
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        if (dictionary["forwards"] != nil) { forwards = Forwards.modelsFromDictionaryArray(array: dictionary["forwards"] as! NSArray) }
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        
        return dictionary
    }
}

public class Busy {
    public var id : Int?
    public var forwards : Array<Forwards>?
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        if (dictionary["forwards"] != nil) { forwards = Forwards.modelsFromDictionaryArray(array: dictionary["forwards"] as! NSArray) }
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        
        return dictionary
    }
}

public class Forwards {
    public var dests : Array<Dests>?
    public var filters : Array<Filters>?
    
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["dests"] != nil) { dests = Dests.modelsFromDictionaryArray(array: dictionary["dests"] as! NSArray) }
        if (dictionary["filters"] != nil) { filters = Filters.modelsFromDictionaryArray(array: dictionary["filters"] as! NSArray) }
    }
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Forwards]
    {
        var models:[Forwards] = []
        for item in array
        {
            models.append(Forwards(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        
        return dictionary
    }
}

public class Filters {
    public var entity : Entity?
    public var add : String?
    
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["entity"] != nil) { entity = Entity(dictionary: dictionary["entity"] as! NSDictionary) }
        add = dictionary["add"] as? String
    }
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Filters]
    {
        var models:[Filters] = []
        for item in array
        {
            models.append(Filters(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.entity?.dictionaryRepresentation(), forKey: "entity")
        dictionary.setValue(self.add, forKey: "add")
        
        return dictionary
    }
}

public class Dests {
    public var entity : Entity?
    public var timeout : Int?
    
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["entity"] != nil) { entity = Entity(dictionary: dictionary["entity"] as! NSDictionary) }
        timeout = dictionary["timeout"] as? Int
    }
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Dests]
    {
        var models:[Dests] = []
        for item in array
        {
            models.append(Dests(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.entity?.dictionaryRepresentation(), forKey: "entity")
        dictionary.setValue(self.timeout, forKey: "timeout")
        
        return dictionary
    }
}

public class Entity {
    public var type : String?
    public var data : String?
    public var dataObj : DataObj?
    
    required public init?(dictionary: NSDictionary) {
        
        type = dictionary["type"] as? String
        if type != nil && type == "USER" {
            if (dictionary["data"] != nil) {
                dataObj = DataObj(dictionary: dictionary["data"] as! NSDictionary)
            }
        }
        else {
            data = dictionary["data"] as? String
        }
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.type, forKey: "type")
        if type != nil && type == "USER" {
            dictionary.setValue(self.dataObj?.dictionaryRepresentation(), forKey: "data")
        }
        else {
            dictionary.setValue(self.data, forKey: "data")
        }
        
        return dictionary
    }
    
    func getTypeChoice() -> TypeChoice! {
        switch type! {
        case "PHONE":
            return TypeChoice.Phone
        case "MEVO":
            return TypeChoice.Mevo
        case "USER":
            return TypeChoice.Mobile
        case "E164":
            return TypeChoice.CustomNumber
        case "NONE":
            return TypeChoice.None
        default:
            return TypeChoice.Other
        }
    }
}

public class DataObj {
    public var dest : String?
    public var id : String?
    
    
    required public init?(dictionary: NSDictionary) {
        
        dest = dictionary["dest"] as? String
        id = dictionary["id"] as? String
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.dest, forKey: "dest")
        dictionary.setValue(self.id, forKey: "id")
        
        return dictionary
    }
}

