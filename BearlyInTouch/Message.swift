//
//  Message.swift
//
//  Created by super on 11/20/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit

import Firebase

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timeStamp: NSNumber?
    var toId: String?
    
    func chatPartnerId() -> String?{
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId: fromId
    }
}
