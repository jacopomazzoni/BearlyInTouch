//
//  ViewController.swift
//  BearlyInTouch
//
//  Created by super on 11/14/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class MessageController: UITableViewController {

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add Logout button to navbar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: #selector(handleNewMessage))

        //handling the user not logged in
        checkIfUserIsLoggedIn()

        
      
    }
    
    func handleNewMessage () {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        presentViewController(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn(){
        
        if FIRAuth.auth()?.currentUser?.uid == nil{
            performSelector(#selector(handleLogout), withObject: nil,afterDelay: 0)
            handleLogout()
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let dictionary = snapshot.value as? [String : AnyObject] {
                        self.navigationItem.title = dictionary["email"] as? String
                    }
                }, withCancelBlock: nil )
            
            
        }
    }
    
    
    func handleLogout(){
        
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        presentViewController(loginController, animated: true, completion: nil)
    }


}

