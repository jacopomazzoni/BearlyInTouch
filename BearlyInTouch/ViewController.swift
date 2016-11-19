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

class ViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        
        //handling the user not logged in
        if FIRAuth.auth()?.currentUser?.uid == nil{
            performSelector(#selector(handleLogout), withObject: nil,afterDelay: 0)
            handleLogout()
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

