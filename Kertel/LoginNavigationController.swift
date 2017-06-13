//
//  LoginNavigationController.swift
//  Kertel
//
//  Created by Kertel on 06/06/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class LoginNavigationController: UINavigationController, APIControllerProtocol{

    var apiController : APIController?
    var autoConnect = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "root view controller" {
            let vc = segue.destination as! LoginViewController
            vc.autoConnect = autoConnect
        }
    }
}
