//
//  DirectoryController.swift
//  Kertel
//
//  Created by Kertel on 21/08/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class DirectoryController: UIViewController, APIControllerProtocol, UISearchBarDelegate {
    
    var apiController : APIController? //set by loginViewController
    var directoryPageVC: DirectoryPageViewController?
    @IBOutlet weak var tabSegementControl: UISegmentedControl!
    @IBOutlet weak var addContactButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title : "add", style: .plain, target: self, action: #selector(deleteAllButton(sender :)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let directoryPageVC = segue.destination as? DirectoryPageViewController, segue.identifier == "directoryPageEmbed" {
            self.directoryPageVC = directoryPageVC
            directoryPageVC.parentDirectoryController = self
        }
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        directoryPageVC?.search(search: searchText.lowercased().folding(options: .diacriticInsensitive, locale: .current))
    }
    
    @IBAction func addContactAction(_ sender: Any) {
        let newContactDirectoryVC = storyboard?.instantiateViewController(withIdentifier: "newContactTVC") as! NewContactTableViewController
        newContactDirectoryVC.apiController = apiController
        newContactDirectoryVC.directoryTVC = directoryPageVC?.userDirectoryTVC
        navigationController?.pushViewController(newContactDirectoryVC as UIViewController, animated: true)
    }
    
    @IBAction func onChangeTab(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            directoryPageVC?.firstPage()
        }
        else {
            directoryPageVC?.secondPage()
        }
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

//Embed UIView
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
        companyDirectoryTVC.directoryController = parentDirectoryController
        
        userDirectoryTVC = storyboard?.instantiateViewController(withIdentifier: "TVCDirectory") as! DirectoryTableViewController
        userDirectoryTVC.apiController = parentDirectoryController.apiController
        userDirectoryTVC.isUserContact = true
        userDirectoryTVC.directoryController = parentDirectoryController
        
        companyVC = companyDirectoryTVC
        userVC = userDirectoryTVC
        
        
        setViewControllers([companyVC], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    func search(search : String) {
        companyDirectoryTVC.search(search: search)
        userDirectoryTVC.search(search: search)
    }
    
    // change tabSegementControl when gesture switch page finished
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        /*if let currentPageTVC : DirectoryTableViewController = viewControllers?[0] as? DirectoryTableViewController {
            if currentPageTVC.isUserContact {
                print("is UserContact")
            }
            else {
                print("is CompanyContact")
            }
        }*/
        
        if pageViewController.viewControllers![0] == userVC {
            parentDirectoryController.tabSegementControl.selectedSegmentIndex = 1
        }
        else {
            parentDirectoryController.tabSegementControl.selectedSegmentIndex = 0
        }
    }
    
    func firstPage()
    {
        setViewControllers([companyDirectoryTVC], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
    }
    
    func secondPage()
    {
        setViewControllers([userDirectoryTVC], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
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
