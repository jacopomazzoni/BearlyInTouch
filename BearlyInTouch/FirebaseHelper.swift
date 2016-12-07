//
//  FirebaseHelper.swift
//
//
//  Created by super on 12/4/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FirebaseHelper {
    
    var Success : Bool
    //var Email : String?
    var auth : FIRAuth?
    var db : FIRDatabase?
    var user : FIRUser?
    init() {
        self.Success = false
        //self.Email = nil
        self.auth = FIRAuth.auth()
        self.db = FIRDatabase.database()
        self.user = nil
    }
    
    /*func getAuth () -> Any{
        return self.auth
    }*/
    
    /*func getEmail() -> String? {
        return self.Email
    }*/
    
    func handleRegister( mail : String?, pass:
        String? ) {
       }
}