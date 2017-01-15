//
//  ViewController.swift
//  Orel
//
//  Created by Etjen Ymeraj on 2/13/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import FBSDKCoreKit
import FBSDKLoginKit

var nameLabel = UILabel()

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, FBSDKLoginButtonDelegate{
    

    
    var logInViewController: PFLogInViewController! = PFLogInViewController()
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PFUser.logOut()
        let logInButton = FBSDKLoginButton()
        logInButton.readPermissions = ["public_profile", "email", "user_friends"]
        logInButton.center = self.view.center
        
        logInButton.delegate = self
        self.view.addSubview(logInButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.current() == nil){
            self.logInViewController.fields = [.usernameAndPassword, .logInButton, .signUpButton, .passwordForgotten, .dismissButton]
            
            let logInLogoTitle = UILabel()
            logInLogoTitle.text = "Orel"
            
            self.logInViewController.logInView!.logo = logInLogoTitle
            self.logInViewController.delegate = self
            
            let signUpLogoTitle = UILabel()
            signUpLogoTitle.text = "Orel"
            
            self.signUpViewController.signUpView!.logo = signUpLogoTitle
            self.signUpViewController.delegate = self
            
            self.logInViewController.signUpController = self.signUpViewController
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //facebook
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil{
            print("ok")
            self.performSegue(withIdentifier: "profile", sender: self)
            returnUserData()
        }
        else {
            print(error)
        }
       
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let id: NSString = result.value(forKey: "id") as! NSString
                print(id)
                let userName : NSString = result.value(forKey: "name") as! NSString
                print("User Name is: \(userName)")
                nameLabel.text = userName as String
            }
        })
    }

    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out")
    }
    

    //login
    func log(_ logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if(!username.isEmpty || !password.isEmpty){
            return true
        }else{
            return false
            }
        
    }
    
    func log(_ logInController: PFLogInViewController, didLogIn user: PFUser) {
        self.dismiss(animated: true, completion: nil)
        print("success")
        nameLabel.text = PFUser.current()?.username
        self.performSegue(withIdentifier: "profile", sender: self)
        
       
        
    }
    
    func log(_ logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("failed to login")
    }
    
    //signup
    
    func signUpViewController(_ signUpController: PFSignUpViewController, didSignUp user: PFUser) {
        self.dismiss(animated: true, completion: nil)
        nameLabel.text = PFUser.current()?.username
        self.performSegue(withIdentifier: "profile", sender: self)

    }
    
    func signUpViewController(_ signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("failed to sign up")
    }
    
    func signUpViewControllerDidCancelSignUp(_ signUpController: PFSignUpViewController) {
        print("user dismissed sign up")
    }
    
    @IBAction func parse(_ sender: AnyObject) {
        
        self.present(self.logInViewController, animated: true, completion: nil)
        
    }
    
    
}

