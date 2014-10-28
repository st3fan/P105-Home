//
//  LoginViewController.swift
//  P105-Home
//
//  Created by Darrin Henein on 2014-10-27.
//  Copyright (c) 2014 Darrin Henein. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    var loginModal: UIView?
    var emailField:UITextField!
    var passwordField:UITextField!
    var loginButton:UIBarButtonItem!
    var toolbar:UIToolbar!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var Spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let objects = UINib(nibName: "LoginModal", bundle: nil).instantiateWithOwner(nil, options: nil)
        loginModal = objects[0] as? UIView

        emailField = loginModal?.viewWithTag(1) as UITextField
        passwordField = loginModal?.viewWithTag(2) as UITextField
        toolbar = loginModal?.viewWithTag(3) as UIToolbar
        loginButton = toolbar.items?[1] as UIBarButtonItem

        loginButton.target = self
        loginButton.action = Selector("loginPressed")

        emailField.layer.borderColor = UIColor(red:1.000, green:0.522, blue:0.039, alpha: 1).CGColor
        passwordField.layer.borderColor = UIColor(red:1.000, green:0.522, blue:0.039, alpha: 1).CGColor
        
        self.loginModal!.center = self.view.center
        self.view.addSubview(loginModal!)
    }
    
    func loginPressed() {
        let syncTabs = "https://syncapi-dev.sateh.com/1.0/tabs"
        Spinner.startAnimating()
        Alamofire.request(.GET, syncTabs, parameters: nil)
            .authenticate(user: self.emailField.text, password: self.passwordField.text)
            .responseJSON { (req, res, data, error) in
                
                println(res)
                self.Spinner.stopAnimating()
                if res?.statusCode == 200 {
                    if Login().setKeychainUser(self.emailField.text, password: self.passwordField.text) == true {
                        if let vc = self.presentingViewController as? canFetchData {
                            vc.fetchData()
                        }
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                } else {
                    self.ErrorLabel.text = "Incorrect username or password."
                    self.shake()
                }

            }
    }
    
    func shake() {
        UIView.animateWithDuration(0.1, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: nil, animations: {
            println("Animating")
            self.loginModal?.transform = CGAffineTransformMakeTranslation(-10, 10)
            }, completion:  nil)
        UIView.animateWithDuration(0.1, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: nil, animations: {
            println("Animating")
            self.loginModal?.transform = CGAffineTransformMakeTranslation(10, -10)
            }, completion:  nil)
        UIView.animateWithDuration(0.1, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: nil, animations: {
            println("Animating")
            self.loginModal?.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion:  nil)
    }
    
    func removeLogin() {
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: nil, animations: {
            
            println("Animating")
            self.loginModal?.transform = CGAffineTransformMakeTranslation(0, -400)
            
            }, completion:  nil)
    }
    
    func popLogin() {
        
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: nil, animations: {
            
            println("Animating")
            self.loginModal?.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }, completion: { finished in
                
                println("Done")
        })
        
    }

}
