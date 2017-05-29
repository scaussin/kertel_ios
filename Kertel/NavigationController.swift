//
//  NavigationController.swift
//  Kertel
//
//  Created by Kertel on 29/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    var apiController : APIController?
    
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
            var vc = segue.destination as! APIControllerProtocol
            vc.apiController = self.apiController
        }
    }
    
}
