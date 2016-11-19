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


}

