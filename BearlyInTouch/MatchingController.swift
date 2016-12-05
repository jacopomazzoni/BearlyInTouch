//
//  ChatLogController.swift
//  BearlyInTouch
//
//  Created by Jee on 11/21/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MatchingController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    
    var isLiked = false
    var partner = ""
    var matchingString = ""

    var user: User?{
        didSet{
            navigationItem.title = user?.email
            
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        userMessagesRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message()
                //potential of crashing if keys don't match
                message.setValuesForKeysWithDictionary(dictionary)
                
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectionView?.reloadData()
                    })
                }
                
                }, withCancelBlock: nil)
            
            }, withCancelBlock: nil)
    }
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        matchingString = "matching-" + dateFormatter.stringFromDate(NSDate())
        print(matchingString)
        fetchMatch()
        collectionView?.backgroundColor = UIColor.whiteColor()
        updateRightBarButton(isLiked)
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        setupInputComponents()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -50).active = true
        containerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        containerView.heightAnchor.constraintEqualToConstant(50).active = true
        
        let sendButton = UIButton(type: .System)
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), forControlEvents: .TouchUpInside)
        containerView.addSubview(sendButton)
        //sendButton constraints
        sendButton.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor).active = true
        sendButton.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        sendButton.widthAnchor.constraintEqualToConstant(80).active = true
        sendButton.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        
        //Textfield to enter in message
        containerView.addSubview(inputTextField)
        //textfield constraints
        inputTextField.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 8).active = true
        inputTextField.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        inputTextField.rightAnchor.constraintEqualToAnchor(sendButton.leftAnchor).active = true
        inputTextField.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.blackColor()
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor).active = true
        separatorLineView.topAnchor.constraintEqualToAnchor(containerView.topAnchor).active = true
        
        separatorLineView.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor).active = true
        separatorLineView.heightAnchor.constraintEqualToConstant(1).active = true
    }
    
    func handleSend(){
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timeStamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toId": toId, "fromId": fromId, "timeStamp": timeStamp]
        childRef.updateChildValues(values){(error, ref) in
            if error != nil{
                print(error)
                return
            }
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId)
            recipientUserMessagesRef.updateChildValues([messageId:1])
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    private func fetchMatch() -> User{
        let user = User()
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            print("user is nil!")
            return user // maybe return something else if the user is not authorized?
        }
        print(uid)
        FIRDatabase.database().reference().child(matchingString).child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            print("Your match is:")
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let partnerMatch = dictionary["myMatch"] as? String
                if let partnerString = partnerMatch{
                    self.partner = partnerString
                    print(self.partner)
                    FIRDatabase.database().reference().child("users").child(partnerString).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        if let dictionary = snapshot.value as? [String : AnyObject] {
                            let matchEmail = dictionary["email"] as? String
                            if let partnerEmailString = matchEmail{
                                //let user = User()
                                user.id = partnerMatch
                                user.email = matchEmail
                                self.user = user
                                
                                self.navigationItem.title = partnerEmailString
                            }else{
                                print("fail")
                            }
                        }
                        }, withCancelBlock: nil )
                }
                else{
                    print("failed")
                }
                
                let approved = dictionary["approved"] as? Bool
                if let approvedBool = approved{
                    self.isLiked = approvedBool
                    self.updateRightBarButton(self.isLiked)
                    print("inside approved of fetchUSer()")
                }
                else{
                    print("failed inside approved of fetchUser()")
                }
            }
            }, withCancelBlock: nil )
        print ("after fetch user id:")
        print(user)
        return user
    }
    
    func updateRightBarButton(isFavorite: Bool){
        let button = UIButton(frame: CGRectMake(0,0,30,30))
        button.addTarget(self, action: #selector(buttonLikeDidTap), forControlEvents: .TouchUpInside)
        
        if(isFavorite){
            button.setImage(UIImage(named: "HeartsFilled.png"), forState: UIControlState.Normal)
        }
        else{
            button.setImage(UIImage(named: "Hearts.png"), forState: UIControlState.Normal)
        }
        let buttonLike = UIBarButtonItem(customView: button)
        self.navigationItem.setRightBarButtonItems([buttonLike], animated: true)
    }
    func buttonLikeDidTap()
    {
        if self.isLiked {
        }
        else{
            self.isLiked = !self.isLiked;
            approveMatch()
        }
        self.updateRightBarButton(self.isLiked);
    }
    
    func approveMatch(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        
        let ref = FIRDatabase.database().reference()
        ref.child(matchingString).child(uid).child("approved").setValue(1)
        
        
        
        ref.child(matchingString).child(partner).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            //print("Your match is:")
            if let dictionary = snapshot.value as? [String : AnyObject] {
                print(dictionary)
                let approved = dictionary["approved"] as? Bool
                if let approvedBool = approved{
                    print("approved is:")
                    print(approvedBool)
                    if(approvedBool){
                        print("partner also likes you!")
                        let match = [uid:self.partner,self.partner:uid]
                        ref.child("partners").updateChildValues(match){(error, ref) in
                            if error != nil{
                                print(error)
                                return
                            }
                        }
                        
                    }
                    else{
                        print("partner doesnt like you just yet")
                    }
                }
                else{
                    print("failed")
                }
            }
            }, withCancelBlock: nil )
    }
    
}
