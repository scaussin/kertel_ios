//
//  DirectoryController.swift
//  Kertel
//
//  Created by Kertel on 21/08/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class DirectoryController: UIViewController, APIControllerProtocol {
    
    var apiController : APIController? //set by loginViewController

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let directoryPageVC = segue.destination as? DirectoryPageViewController, segue.identifier == "directoryPageEmbed" {
            
            directoryPageVC.parentDirectoryController = self
        }
    }
}

class DirectoryPageViewController : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var companyDirectoryTVC : DirectoryTableViewController!
    var userDirectoryTVC : DirectoryTableViewController!
    
    var parentDirectoryController : DirectoryController! //set by DirectoryController (segue: directoryPageEmbed)
    
    var companyVC :UIViewController!
    var userVC :UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        companyDirectoryTVC = storyboard?.instantiateViewController(withIdentifier: "TVCDirectory") as! DirectoryTableViewController
        companyDirectoryTVC.apiController = parentDirectoryController.apiController
        companyDirectoryTVC.isUserContact = false
        
        userDirectoryTVC = storyboard?.instantiateViewController(withIdentifier: "TVCDirectory") as! DirectoryTableViewController
        userDirectoryTVC.apiController = parentDirectoryController.apiController
        userDirectoryTVC.isUserContact = true
        
        companyVC = companyDirectoryTVC
        userVC = userDirectoryTVC

        setViewControllers([companyVC], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == userVC
        {
            return nil
        }
        return userVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == companyVC
        {
            return nil
        }
        return companyVC
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
