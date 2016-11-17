//
//  ViewController.swift
//  BearlyInTouch
//
//  Created by super on 11/14/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
    }
    func handleLogout(){
        let loginController = LoginController()
        presentViewController(loginController, animated: true, completion: nil)
    }
//        
//
//        //Adding the Logo label
//        var label = UILabel(frame: CGRectMake(0,0,200,21))
//        label.center = CGPointMake(self.view.center.x,160)
//        label.textAlignment = NSTextAlignment.Center
//        label.text = "Bearly In Touch"
//        self.view.addSubview(label)
//        
//        //Adding the TextFields to logIn
//        var rect = CGRectMake(0, 0, 200, 21)
//        var email = UITextField(frame: rect)
//        email.center = CGPointMake(self.view.center.x, 200)
//        email.placeholder = "Email"
//        self.view.addSubview(email)
//        
//        var password = UITextField(frame: rect)
//        password.center = CGPointMake(self.view.center.x, 240)
//        password.placeholder = "Password"
//        password.secureTextEntry  = true
//        self.view.addSubview(password)
//        
//        //Adding the login and Register buttons
//        let buttonRect = CGRect(x: 100, y: 100, width: 100, height: 50) // Modify to change button size.
////        let loginButton = UIButton(frame: buttonRect)
////        loginButton.center = CGPointMake(self.view.center.x, 280)
////        loginButton.backgroundColor = .blueColor()
////        loginButton.setTitle("Login", forState: .Normal)
////        self.view.addSubview(loginButton)
//        
//        let registerButton = UIButton(frame: buttonRect)
//        registerButton.center = CGPointMake(self.view.center.x, 380)
//        registerButton.backgroundColor = .blueColor()
//        registerButton.setTitle("Register", forState: .Normal)
      //  self.view.addSubview(registerButton)
//
//        let logoutButton = UIButton(frame: rect)
//        logoutButton.center = CGPointMake(self.view.center.x, 520)
//        logoutButton.setTitle("Logout", forState: .Normal)
//        self.view.addSubview(logoutButton)


//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }


}

