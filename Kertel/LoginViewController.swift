//
//  LoginViewController.swift
//  Kertel
//
//  Created by Kertel on 15/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit 

class LoginViewController: UIViewController, UITextFieldDelegate,  APIDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var apiController : APIController?
    //var logins : [Login] = []
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var company: UITextField!
    var alertController : UIAlertController? = nil
    var autoConnect = true
    
    @IBOutlet weak var switchUsernameCompany: UISwitch!
    @IBOutlet weak var switchPassword: UISwitch!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController -> viewDidLoad")
        
        apiController = APIController()
        let defaults = UserDefaults.standard
        username.text = defaults.string(forKey: "username")
        company.text = defaults.string(forKey: "company")
        password.text = defaults.string(forKey: "password")
        
        if (autoConnect && (username.text?.characters.count)! > 0 && (company.text?.characters.count)! > 0 && (password.text?.characters.count)! > 0)
        {
            connectButton(0)
            return
        }
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        
        var boolSwitchUsernameCompany = true
        var boolSwitchPassword = true
        if defaults.integer(forKey: "switchUsernameCompany") == -1
        {
            boolSwitchUsernameCompany = false
        }
        if defaults.integer(forKey: "switchPassword") == -1
        {
            boolSwitchPassword = false
        }
        
        switchUsernameCompany.setOn(boolSwitchUsernameCompany , animated: false)
        switchPassword.setOn(boolSwitchPassword, animated: false)
        
        username.delegate = self
        password.delegate = self
        company.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("LoginViewController -> viewDidAppear")
    }

    
    func keyboardWillShow(notification : NSNotification){
        print("keyboardWillShow")
     
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                scrollViewHeightConstraint.constant = -keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification : NSNotification){
            scrollViewHeightConstraint.constant = 0
    }
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == username
        {
            company.becomeFirstResponder()
        }
        else if textField == company
        {
            password.becomeFirstResponder()
        }
        else if textField == password
        {
            connectButton(0)
        }
        return true
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
            
            //connecting
            alertController = UIAlertController(title: nil, message: "Connexion en cours...\n\n", preferredStyle: .alert)
            let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
            spinnerIndicator.color = UIColor.black
            spinnerIndicator.startAnimating()
            alertController?.view.addSubview(spinnerIndicator)
            self.present(alertController!, animated: true, completion: nil)
            
            apiController?.getToken(delegate: self, username: username.text!, company: company.text!, password: password.text!)
            
        }
        else
        {
            let alert = UIAlertController(title: "Erreur", message: "Veuillez remplir tous les champs", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        DispatchQueue.main.sync {
            alertController?.dismiss(animated: false){
                let alert = UIAlertController(title: "Erreur d'authentification", message: "Veuillez vérifier vos informations de connexion", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainSegue" {
            let vc = segue.destination as! MainTabBarController
            vc.apiController = self.apiController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
