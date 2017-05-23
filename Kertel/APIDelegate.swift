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
    func receiveData(data : [AnyObject])
    func error(msgError : String)
}


protocol APIDelegateConnect
{
    func success()
    func fail(msgError : String)
}
