//
//  APIController.swift
//  Kertel
//
//  Created by Kertel on 09/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation


class APIController {
    
    
    var delegate: APIDelegate!
    
    init(delegate : APIDelegate!)
    {
        self.delegate = delegate
    }
    
}
