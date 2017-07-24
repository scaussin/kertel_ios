//
//  APIDelegate.swift
//  Kertel
//
//  Created by Kertel on 09/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation

protocol APIDelegate
{
    func success(data : [AnyObject]?)
    func fail(msgError : String)
}

protocol APIDelegateRawData
{
    func success(data : NSData?)
    func fail(msgError : String)
}

/*
protocol APIDelegateConnect
{
    func success()
    
}*/

protocol APIControllerProtocol
{
    var apiController : APIController? {get set}
}
