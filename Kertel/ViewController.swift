//
//  ViewController.swift
//  Kertel
//
//  Created by Kertel on 19/04/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var APIController : APIController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //try APIController.getToken()
        print("ViewController -> viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

