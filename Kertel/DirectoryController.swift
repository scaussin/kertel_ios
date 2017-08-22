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
    
    var pages = [UIViewController]()
    
    var sharedDirectoryTVC = DirectoryTableViewController()
    var persoDirectoryTVC = DirectoryTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        //let table : UITableViewController! = (storyboard?.instantiateViewController(withIdentifier: "table"))! as! UITableViewController
        sharedDirectoryTVC.data = ["1","2","3"]
        persoDirectoryTVC.data = ["4","5","6"]
        
        let page1: UIViewController! = sharedDirectoryTVC
        let page2: UIViewController! = persoDirectoryTVC
        //let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "table")
        //let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "table")
        
        
        pages.append(page1)
        pages.append(page2)
        
        setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        //let previousIndex = abs((currentIndex - 1) % pages.count)
        if currentIndex == 1
        {
            return nil
        }
        return pages[1]
        //return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        //let nextIndex = abs((currentIndex + 1) % pages.count)
        if currentIndex == 0
        {
            return nil
        }
        return pages[0]
        //return pages[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
