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
    
    @IBOutlet weak var switchUsernameCompany: UISwitch!
    @IBOutlet weak var switchPassword: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        print("LoginViewController -> viewDidLoad")
        
        let defaults = UserDefaults.standard
        username.text = defaults.string(forKey: "username")
        company.text = defaults.string(forKey: "company")
        password.text = defaults.string(forKey: "password")
        
        
        var boolSwitchUsernameCompany = true
        
        if defaults.integer(forKey: "switchUsernameCompany") == -1
        {
            boolSwitchUsernameCompany = false
        }
        
        var boolSwitchPassword = true
        if defaults.integer(forKey: "switchPassword") == -1
        {
            boolSwitchPassword = false
        }
        
        switchUsernameCompany.setOn(boolSwitchUsernameCompany , animated: false)
        switchPassword.setOn(boolSwitchPassword, animated: false)
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
    
    func switchStateToInt(switchState : Bool!) -> Int
    {
        if (switchState == true)
        {
            return 1
        }
        else
        {
            return -1
        }
        
    }
    
    @IBAction func connectButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: "Connexion en cours...\n\n", preferredStyle: .alert)
        
        let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: true, completion: nil)
        
        
        return
        
        username.text = username.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        company.text = company.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if ((username.text?.characters.count)! > 0 && (company.text?.characters.count)! > 0 && (password.text?.characters.count)! > 0 )
        {
            let defaults = UserDefaults.standard
            defaults.set(switchStateToInt(switchState: switchUsernameCompany.isOn), forKey: "switchUsernameCompany")
            defaults.set(switchStateToInt(switchState: switchPassword.isOn), forKey: "switchPassword")
            
            if (switchUsernameCompany.isOn)
            {
                defaults.set(username.text, forKey: "username")
                defaults.set(company.text, forKey: "company")
            }
            else
            {
                defaults.set(nil, forKey: "username")
                defaults.set(nil, forKey: "company")
            }
            if (switchPassword.isOn)
            {
                defaults.set(password.text, forKey: "password")
            }
            else
            {
                defaults.set(nil, forKey: "password")
            }
            
            performSegue(withIdentifier: "toConnectSegue", sender: self)
        }
        else
        {
            let alert = UIAlertController(title: "Erreur", message: "Veuillez remplir tous les champs", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        /*getData()
        if logins.count > 0
        {
            context.delete(logins[0])
        }
        
        let login = Login(context: context) // Link Task & Context*/
        // Save the data to coredata
        //(UIApplication.shared.delegate as! AppDelegate).saveContext()

       
    }
    
    /*func getData() {
        do {
            logins = try context.fetch(Login.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }*/

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "toConnectSegue")
        {
            let vc = segue.destination as! ConnectViewController
            vc.username = username.text!
            vc.company = company.text!
            vc.password = password.text!
        }
    }


}
