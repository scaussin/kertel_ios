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

        // Do any additional setup after loading the view.
    }
    @IBAction func disconnect(_ sender: Any) {
        
        print("##################################")
        print("disconnect")
        apiController!.token = nil
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
            let vc = segue.destination.childViewControllers.first as! LoginViewController
            vc.autoConnect = false
        }
    }
    

}
