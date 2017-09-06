//
//  SettingViewController.swift
//  Kertel
//
//  Created by Kertel on 05/06/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class SettingVC: UIViewController, APIControllerProtocol{
  
    var apiController : APIController? //set by loginViewController
    var settingEmbedPVC : SettingEmbedPVC?
    @IBOutlet weak var tabSegementControl: UISegmentedControl!
    var loginViewController : LoginViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SettingViewController load")
    }

    @IBAction func onChangeTabBar(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            settingEmbedPVC?.firstPage()
        }
        else {
            settingEmbedPVC?.secondPage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingPageVC = segue.destination as? SettingEmbedPVC, segue.identifier == "settingPageEmbed" {
            self.settingEmbedPVC = settingPageVC
            settingEmbedPVC?.parentDirectoryController = self
        }
    }
}

//Embed UIView
class SettingEmbedPVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var profileVC : ProfileVC!
    var settingCallTVC : SettingCallTVC!
    var parentDirectoryController : SettingVC! //set by SettingVC (segue: settingPageEmbed)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        profileVC = storyboard?.instantiateViewController(withIdentifier: "profileVC") as! ProfileVC
        profileVC.apiController = parentDirectoryController.apiController
        profileVC.loginViewController = parentDirectoryController.loginViewController
        
        settingCallTVC = storyboard?.instantiateViewController(withIdentifier: "settingCallVC") as! SettingCallTVC
        settingCallTVC.apiController = parentDirectoryController.apiController

        setViewControllers([profileVC], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    // change tabSegementControl when gesture switch page finished
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if pageViewController.viewControllers![0] == settingCallTVC {
            parentDirectoryController.tabSegementControl.selectedSegmentIndex = 1
        }
        else {
            parentDirectoryController.tabSegementControl.selectedSegmentIndex = 0
        }
    }
    
    func firstPage()
    {
        setViewControllers([profileVC], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
    }
    
    func secondPage()
    {
        setViewControllers([settingCallTVC], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == settingCallTVC
        {
            return nil
        }
        return settingCallTVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == profileVC
        {
            return nil
        }
        return profileVC
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
}



