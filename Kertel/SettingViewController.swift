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
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
