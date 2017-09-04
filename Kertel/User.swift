//
//  User.swift
//  Kertel
//
//  Created by Kertel on 01/09/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation

class User {
    var id : String?
    var firstname : String?
    var lastname : String?
    var mail : String?
    var mobile : String?
    var telephone : String?
    var fax : String?
    var shortNumber : String?

    init(id : String?, firstname : String?, lastname : String?, mobile : String?, telephone : String?, fax : String?, mail : String?, shortNumber : String?) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.shortNumber = shortNumber
        self.mobile = mobile
        self.telephone = telephone
        self.fax = fax
        self.mail = mail
    }

    func getName() -> String
    {
        var name = ""
        if firstname != nil
        {
            name = (firstname?.capitalized)!
            if lastname != nil
            {
                name.append(" ")
            }
        }
        if lastname != nil
        {
            name.append((lastname?.capitalized)!)
        }
        return name
    }
}
