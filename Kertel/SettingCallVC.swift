//
//  SettingCallVC.swift
//  Kertel
//
//  Created by Kertel on 04/09/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class SettingCallVC: UIViewController, APIControllerProtocol{

    var apiController : APIController? //set by SettingEmbedPVC (in SettingVC.swift)
    //var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //refresh
        /*refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        view.addSubview(refresher)*/

        // Do any additional setup after loading the view.
    }

    func refresh(){
        //refresher.endRefreshing()
        print("refresh")
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
