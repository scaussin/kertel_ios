//
//  LoginViewController.swift
//  Kertel
//
//  Created by Kertel on 15/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var apiController : APIController?
    
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
    
   /* func success()
    {
        performSegue(withIdentifier: "toMainSegue", sender: self)
    }
    
    func fail(msgError : String)
    {
        let alertController = UIAlertController(title: "Erreur", message: "Echec de l'authentification.\nVérifiez vos identifiants.", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }*/

    
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
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
        performSegue(withIdentifier: "toConnectSegue", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "toConnectSegue")
        {
            let vc = segue.destination as! ConnectViewController
            vc.toMain = true
        }
    }


}
