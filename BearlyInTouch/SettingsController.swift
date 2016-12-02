//
//  SettingsController.swift
//  BearlyInTouch
//
//  Created by super on 12/2/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

//GLOBALS


class SettingsController: UITableViewController {
    
    let profileImageView :UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bear")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add Logout button to navbar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        //self.view.subviews.append(profileImageView)
    }
    
    
    func handleLogout(){
        
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        loginController.messagesController = nil
        presentViewController(loginController, animated: true, completion: nil)
    }
    
}




/*
 let inputsContainerView : UIView = {
 let view = UIView()
 view.backgroundColor = UIColor.whiteColor()
 view.translatesAutoresizingMaskIntoConstraints = false
 view.layer.cornerRadius = 10
 view.layer.masksToBounds = true
 return view
 }()
 
 let profileImageView :UIImageView = {
 let imageView = UIImageView()
 imageView.image = UIImage(named: "bear")
 imageView.translatesAutoresizingMaskIntoConstraints = false
 return imageView
 }()
 lazy var loginRegisterButton: UIButton = {
 let button = UIButton(type: .System)
 button.backgroundColor = UIColor.whiteColor()
 //UIColor(r: 244, g: 72, b: 66 )
 button.setTitle("Register", forState: .Normal)
 button.translatesAutoresizingMaskIntoConstraints = false
 button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
 button.layer.cornerRadius = 5
 button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
 button.setTitleColor(theColor, forState: .Normal)
 return button
 }()*/