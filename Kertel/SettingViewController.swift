//
//  SettingViewController.swift
//  Kertel
//
//  Created by Kertel on 05/06/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController , APIDelegate{

    var apiController : APIController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SettingViewController load")
        let mainTBC = self.parent as! MainTabBarController
        self.apiController = mainTBC.apiController

        // Do any additional setup after loading the view.
    }
    @IBAction func disconnect(_ sender: Any) {
        apiController?.token = nil
        
    }
    
    
    func success(data: [AnyObject]) {
        
    }
    
    func fail(msgError : String)
    {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLoginSegue" {
            let vc = segue.destination as! LoginNavigationController
            vc.autoConnect = false
        }
    }
    

}
