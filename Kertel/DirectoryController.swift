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

        // Do any additional setup after loading the view.
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

class DirectoryPageViewController : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //var pages = [UIViewController]()
    var sharedVC :UIViewController!
    var persoVC :UIViewController!
    
    var sharedDirectoryTVC : DirectoryTableViewController!
    var persoDirectoryTVC : DirectoryTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        sharedDirectoryTVC = storyboard?.instantiateViewController(withIdentifier: "TVCDirectory") as! DirectoryTableViewController
        sharedDirectoryTVC.data = ["partagé","2","3","1","2","3","1","2","3","1","2","3"]
        
        persoDirectoryTVC = storyboard?.instantiateViewController(withIdentifier: "TVCDirectory") as! DirectoryTableViewController
        persoDirectoryTVC.data = ["perso","2","3","1","2","3","1","2","3","1","2","3"]
        
        sharedVC = sharedDirectoryTVC
        persoVC = persoDirectoryTVC
        //let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "VCTest")
        //let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "table")
        
        
        //pages.append(page2)
        
        setViewControllers([sharedVC], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == persoVC
        {
            return nil
        }
        return persoVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == sharedVC
        {
            return nil
        }
        return sharedVC
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 1
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
