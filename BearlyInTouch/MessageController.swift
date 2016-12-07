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
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //var navigationBarAppearace = UINavigationBar.appearance()
        
        
        //navigationBarAppearace.tintColor = UIColor.brownColor()
        //navigationBarAppearace.barTintColor = UIColor.brownColor()
        
        

        // Add Logout button to navbar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: #selector(handleNewMessage))
        
        //handling the user not logged in
        checkIfUserIsLoggedIn()
        
        self.navigationItem.title = "Messages"
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        viewDidLoad()
    }
    
    
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
  
    
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
                    let message = Message()
                    
                   
                    
                    //message.setValuesForKeysWithDictionary(dictionary)
                    // Conveninence initializer is evil this is less sexy but safer
                    message.fromId = dictionary["fromId"] as? String
                    message.text = dictionary["text"] as? String
                    message.toId  = dictionary["toId"] as? String
                    message.timeStamp = dictionary["timeStamp"] as? NSNumber
                    
                    
                    
                    //group the messages together
                    if let chatPartnerId = message.chatPartnerId(){
                        
                        self.messagesDictionary[chatPartnerId] = message
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
                let message = Message()
                message.setValuesForKeysWithDictionary(dictionary)
                self.messagesDictionary = [String : Message]()
                self.messages = [Message]()
                
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
                
        let message = messages[indexPath.row]
        cell.message = message
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
            user.email = dictionary["email"] as? String
            //user.setValuesForKeysWithDictionary(dictionary)
            //print("dictionary \(snapshot)")
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
                
                
                if let navEmail = dictionary["email"] as? String{
                    let index = navEmail.rangeOfString("@", options: .BackwardsSearch)?.startIndex
                    let navEmail = navEmail.substringToIndex(index!)
                    //navEmail
                    
//                    if let idx = navEmail.characters.indexOf("@") {
//                        let pos = navEmail.startIndex.distanceTo(idx)
//                        let navBarName = navEmail.
//                    }
                }
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

