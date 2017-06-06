//
//  ConnectViewController.swift
//  Kertel
//
//  Created by Kertel on 23/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit
import CoreData

class ConnectViewController: UIViewController,  APIDelegate{

    var apiController : APIController?
    var username : String?
    var company : String?
    var password : String?
    
    //var logins : [Login] = []
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiController = APIController()
        print("ConnectViewController -> viewDidLoad")
        //let task = Login(context: context) // Link Task & Context
        /*getData()
        if (logins.count > 0 && logins[0].username != nil && logins[0].company != nil && logins[0].password != nil)
        {
            let username = logins[0].username
            let company = logins[0].company
            let password = logins[0].password
            
            print("username: \(String(describing: username))")
            print("company: \(String(describing: company))")
            print("password: \(String(describing: password))")
            
            APIController.getToken(delegate: self, username: username!, company: company!, password: password!)
        }
        else
        {
             performSegue(withIdentifier: "toLoginSegue", sender: self)
        }*/
        
        //(UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    override func viewDidAppear(_ animated: Bool) {
        print("ConnectViewController -> viewDidAppear")
        let defaults = UserDefaults.standard

        if (username == nil)
        {
            username = defaults.string(forKey: "username")
        }
        if (company == nil)
        {
            company = defaults.string(forKey: "company")
        }
        if (password == nil)
        {
            password = defaults.string(forKey: "password")
        }
        
        if username != nil && company != nil && password != nil
        {
            print("username: \(String(describing: username))")
            print("company: \(String(describing: company))")
            print("password: \(String(describing: password))")
            
            apiController?.getToken(delegate: self, username: username!, company: company!, password: password!)
        }
        else
        {
            performSegue(withIdentifier: "toLoginSegue", sender: self)
        }
    }

    
    func success(data : [AnyObject])
    {
        DispatchQueue.main.sync {
            performSegue(withIdentifier: "toMainSegue", sender: self)
        }

    }
    
    func fail(msgError : String)
    {
        print("fail getToken: \(msgError)")
        
       /*let alert = UIAlertController(title: "Erreur", message: "Erreur lors de l'authentification", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)*/
        
        //let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "logvc") as! LoginViewController
        
        //self.present(secondViewController, animated: true, completion: nil)
        DispatchQueue.main.sync {
            performSegue(withIdentifier: "toLoginSegue", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLoginSegue" {
            var vc = segue.destination as! APIControllerProtocol
            vc.apiController = self.apiController
        }
        else if segue.identifier == "toMainSegue" {
            let vc = segue.destination as! MainTabBarController
            vc.apiController = self.apiController
        }
    }
    
    /*func getData() {
        do {
            logins = try context.fetch(Login.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
