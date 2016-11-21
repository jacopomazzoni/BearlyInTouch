//
//  NewMessageController.swift
//  BearlyInTouch
//
//  Created by super on 11/20/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class NewMessageController: UITableViewController {

    let cellId = "cellID"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(handleCancel))
        
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
        
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").queryOrderedByChild("users").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dictionary  = snapshot.value as? [String: AnyObject]{
                let user = User()
                user.email = dictionary["email"] as? String
                self.users.append(user)
                self.users.sortInPlace { $0.email < $1.email }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })

            }, withCancelBlock: nil)
    }
    
    func handleCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]
        //let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        cell.textLabel?.text = user.email
        cell.detailTextLabel?.text = user.email
        return cell
        
    }
}

class UserCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
