//
//  ViewController.swift
//  BearlyInTouch
//
//  Created by super on 11/14/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

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
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.lightGrayColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func observeUserMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            let messageId = snapshot.key
            let messageReference = FIRDatabase.database().reference().child("messages").child(messageId)
            messageReference.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    print(dictionary)
                    let message = Message()
                    message.setValuesForKeysWithDictionary(dictionary)
                    
                    //group the messages together
                    if let toId = message.toId{
                        self.messagesDictionary[toId] = message
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sortInPlace({(message1, message2) -> Bool in
                            return message1.timeStamp?.intValue > message2.timeStamp?.intValue
                        })
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
                
                }, withCancelBlock: nil)
            
        }, withCancelBlock: nil)
    }
    
    func observeMessages(){
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                print(dictionary)
                let message = Message()
                message.setValuesForKeysWithDictionary(dictionary)
                
                //group the messages together
                if let toId = message.toId{
                    self.messagesDictionary[toId] = message
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sortInPlace({(message1, message2) -> Bool in
                        return message1.timeStamp?.intValue > message2.timeStamp?.intValue
                    })
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
            
            }, withCancelBlock: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection seciont: Int) -> Int {
        return messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cellId")
        
        let message = messages[indexPath.row]
        
        //text label for the users
        if let toId = message.toId{
            let ref = FIRDatabase.database().reference().child("users").child(toId)
            ref.observeEventType(.Value, withBlock: {(snapshot)
                in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    cell.textLabel?.text = dictionary["email"] as? String
                    cell.textLabel?.font = UIFont.boldSystemFontOfSize(16)
                    
                    
                }
                }, withCancelBlock: nil)
            
        }
        
        //text label for the messages
        cell.detailTextLabel?.text = message.text
        cell.addSubview(self.timeLabel)
        if let seconds = message.timeStamp?.doubleValue{
            let timeStampDate = NSDate(timeIntervalSince1970: seconds)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            timeLabel.text = dateFormatter.stringFromDate(timeStampDate)
        }
        
        
        //UI Label constraints
        timeLabel.rightAnchor.constraintEqualToAnchor(cell.rightAnchor).active = true
        timeLabel.topAnchor.constraintEqualToAnchor(cell.topAnchor, constant: 20).active = true
        timeLabel.widthAnchor.constraintEqualToConstant(100).active = true
        timeLabel.heightAnchor.constraintEqualToAnchor(cell.textLabel?.heightAnchor).active = true
        
        return cell

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else{
            return
        }
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject]
                else{
                    return
            }
            let user = User()
            user.id = chatPartnerId
            print("four")
            print(dictionary)
            user.email = dictionary["email"] as? String
            //user.setValuesForKeysWithDictionary(dictionary)
            print("five")
            self.showChatControllerForUser(user)
        }, withCancelBlock: nil )

    }
    
    func handleNewMessage () {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        presentViewController(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn(){
        
        if FIRAuth.auth()?.currentUser?.uid == nil{
            performSelector(#selector(handleLogout), withObject: nil,afterDelay: 0)
            handleLogout()
        } else {
            
            fetchUserandSetNavBarTitle()
        }
    }
    
    func fetchUserandSetNavBarTitle(){
        
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        //observeMessages()
        observeUserMessages()
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                self.navigationItem.title = dictionary["email"] as? String
            }
            }, withCancelBlock: nil )
    }
    
    func showChatControllerForUser(user: User){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    
    func handleLogout(){
        
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        loginController.messagesController = self
        presentViewController(loginController, animated: true, completion: nil)
    }
    
    
}

