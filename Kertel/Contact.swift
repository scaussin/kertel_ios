//
//  contact.swift
//  Kertel
//
//  Created by Kertel on 23/08/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import Foundation

enum TypeActionInfoContact {
    case NoAction //titleDataTableViewCell
    case CallMobile //titleDataClickableTableViewCell
    case CallTelephone //titleDataClickableTableViewCell
    case WriteMail //titleDataClickableTableViewCell
    case EmptyCase
    case Edit //titleClickableTableViewCell
    case Delete //titleClickableTableViewCell
}

class Contact {
    var id : String?
    var firstname : String?
    var lastname : String?
    var company : String?
    var mobile : String?
    var telephone : String?
    var fax : String?
    var mail : String?
    var sortName : String! = ""
    var shared : Bool?
    var isUserContact : Bool
    var infoToDisplay : [InfoToDisplay] = []
    
    
    init(isUserContact : Bool, id : String?, firstname : String?, lastname : String?, company : String?, mobile : String?, telephone : String?, fax : String?, mail : String?, shared : Bool?)
    {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.company = company
        self.mobile = mobile
        self.telephone = telephone
        self.fax = fax
        self.mail = mail
        self.shared = shared
        self.isUserContact = isUserContact
        genSortName()
        fillInfoToDisplay()
    }
    
    func genSortName()
    {
        if lastname != nil {
            sortName = lastname?.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        }
        if firstname != nil {
            sortName.append((firstname?.lowercased())!.folding(options: .diacriticInsensitive, locale: .current))
        }
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
    
    func fillInfoToDisplay()
    {
        if (mobile != nil)
        {
            infoToDisplay.append(InfoToDisplay.init(title : "Portable", data : mobile, action: TypeActionInfoContact.CallMobile))
        }
        if (telephone != nil)
        {
            infoToDisplay.append(InfoToDisplay.init(title : "Téléphone", data : telephone, action: TypeActionInfoContact.CallTelephone))
        }
        if (fax != nil)
        {
            infoToDisplay.append(InfoToDisplay.init(title : "Fax", data : fax, action: TypeActionInfoContact.NoAction))
        }
        if (company != nil)
        {
            infoToDisplay.append(InfoToDisplay.init(title : "Société", data : company, action:TypeActionInfoContact.NoAction))
        }
        if (mail != nil)
        {
            infoToDisplay.append(InfoToDisplay.init(title : "Mail", data : mail, action:TypeActionInfoContact.WriteMail))
        }
        if (shared != nil)
        {
            if shared == true
            {
                infoToDisplay.append(InfoToDisplay.init(title : "Partage", data : "contact partagé", action:TypeActionInfoContact.NoAction))
            }
            else
            {
                infoToDisplay.append(InfoToDisplay.init(title : "Partage", data : "contact non partagé", action:TypeActionInfoContact.NoAction))
            }
        }
        if (isUserContact)
        {
            infoToDisplay.append(InfoToDisplay.init(title : nil, data : nil, action:TypeActionInfoContact.EmptyCase))
            infoToDisplay.append(InfoToDisplay.init(title : "Modifier ce contact", data : nil,action: TypeActionInfoContact.Edit))
            infoToDisplay.append(InfoToDisplay.init(title : "Supprimer ce contact", data : nil,action: TypeActionInfoContact.Delete))
        }
        
        
}
    
    class InfoToDisplay
    {
        var title : String?
        var data : String?
        var action : TypeActionInfoContact!
        
        init (title : String?, data : String?, action : TypeActionInfoContact!)
        {
            self.title = title
            self.data = data
            self.action = action
        }
    }
    
}
