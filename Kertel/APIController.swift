//
//  APIController.swift
//  Kertel
//
//  Created by Kertel on 09/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation


class APIController {
    
    
    var delegateHistoryCall: APIDelegate?
    var delegateMevo: APIDelegate?
    var delegateConnect: APIDelegate?
    var token : String!
    
    
    func getToken(delegate : APIDelegate, username : String?, company : String?, password : String?)
    {
        self.delegateConnect = delegate
        delegateConnect?.success(data: [AnyObject]())
    }
    
    
}
