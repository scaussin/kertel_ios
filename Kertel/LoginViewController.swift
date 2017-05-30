//
//  LoginViewController.swift
//  Kertel
//
//  Created by Kertel on 15/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit 

class LoginViewController: UIViewController, APIControllerProtocol {

    @IBOutlet weak var scrollView: UIScrollView!
    var apiController : APIController?
    //var logins : [Login] = []
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var company: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        print("LoginViewController -> viewDidLoad")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("LoginViewController -> viewDidAppear")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @IBAction func connectButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(username.text, forKey: "username")
        defaults.set(company.text, forKey: "company")
        defaults.set(password.text, forKey: "password")
        
        /*getData()
        if logins.count > 0
        {
            context.delete(logins[0])
        }
        
        let login = Login(context: context) // Link Task & Context*/
        // Save the data to coredata
        //(UIApplication.shared.delegate as! AppDelegate).saveContext()

        performSegue(withIdentifier: "toConnectSegue", sender: self)

    }
    
    /*func getData() {
        do {
            logins = try context.fetch(Login.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }*/

    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "toConnectSegue")
        {
            let vc = segue.destination as! ConnectViewController
        }
    }*/


}
