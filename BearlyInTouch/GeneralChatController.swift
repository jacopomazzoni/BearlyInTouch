//
//  GeneralChatController.swift
//  BearlyInTouch
//
//  Created by Labuser on 12/6/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class GeneralChatController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    
    var generalMessages = [Message]()
    var containerViewBottomAnchor: NSLayoutConstraint?
    let cellId = "cellId"
    var messageHandle = UInt?()
    var ref = FIRDatabase.database()
    let userMessagesRef = FIRDatabase.database().reference().child("general")
    
    var user: User?{
        didSet{
            self.navigationItem.title = "General"
        }
    }
    
    
    
    func scrollToBottom() {
        let indexpath = NSIndexPath(forItem: self.generalMessages.count-1, inSection: 0)
        self.collectionView?.scrollToItemAtIndexPath(indexpath, atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: true)
    }
    
    func scrollToTop() {
        let indexpath = NSIndexPath(forItem: self.generalMessages.count-1, inSection: 0)
        self.collectionView?.scrollToItemAtIndexPath(indexpath, atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "General"
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 80, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        setupInputComponents()
        generalMessages = [Message]()
        print("before")
        //scrollToBottom()
            }
    
    
    override func viewDidDisappear(animated: Bool) {
        //super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        if let handle = messageHandle {
            userMessagesRef.removeObserverWithHandle(handle)
        }
        generalMessages = [Message]()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        generalMessages = [Message]()
        observeMessages()
        setupKeyboardObservers()
//        let contentSize = self.collectionView?.collectionViewLayout.collectionViewContentSize()
//        if(contentSize?.height > self.collectionView?.bounds.size.height){
//            let target = CGPointMake(0.0, (contentSize?.height)!-(self.collectionView?.bounds.size.height)!)
//            self.collectionView?.setContentOffset(target, animated: true)
//        }
        
    }
    
    
    //Keyboard functions
    func setupKeyboardObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        if generalMessages.count > 0 {
            scrollToTop()
        }
        UIView.animateWithDuration(keyboardDuration!){
            self.view.layoutIfNeeded()
        }
    }
    
    func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue

        containerViewBottomAnchor?.constant = -49
        
        UIView.animateWithDuration(keyboardDuration!){
            self.view.layoutIfNeeded()
        }
    }
    
    //Messages to display
    func observeMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            print("uid not fail")
            return
        }
        

        let userMessagesRef = self.userMessagesRef
       
         self.messageHandle = userMessagesRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            let messageTime = snapshot.key
            let messagesRef = userMessagesRef.child(messageTime)
            messagesRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message()
                //potential of crashing if keys don't match
                message.setValuesForKeysWithDictionary(dictionary)
                
                
                self.generalMessages.append(message)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView?.reloadData()
                    // Scroll to the last cell
                    self.scrollToBottom()
                })
                
                }, withCancelBlock: nil)
            
            }, withCancelBlock: nil)
    }
    
    //Textfield to enter in message
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return generalMessages.count
    }
    
    
    //displaying messages
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ChatMessageCell
        
        let message = generalMessages[indexPath.item]
        cell.textView.text = message.text
        cell.textView.editable = false
        setupCell(cell, message: message)
        
        //modify the bubbleView's width
        
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(message.text!).width + 32
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message){
        if message.fromId == FIRAuth.auth()?.currentUser?.uid{
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.whiteColor()
            cell.bubbleRightAnchor?.active = true
            cell.bubbleLeftAnchor?.active = false
            cell.userNameView.hidden = true
        }else{
            //cell.bubbleView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            cell.textView.textColor = UIColor.blackColor()
            cell.bubbleRightAnchor?.active = false
            cell.bubbleLeftAnchor?.active = true
            cell.userNameView.hidden = true
            let userName = message.fromId
            let appendUser = userName?[(userName?.startIndex)!...(userName?.startIndex.advancedBy(3))!]
            cell.bubbleView.backgroundColor = tools.idToColor(appendUser!)
            //cell.userNameView.text = "\(appendUser!)**"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var height : CGFloat = 80
        
        if let text = generalMessages[indexPath.item].text{
            height = estimatedFrameForText(text).height + 22
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil)
    }
    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -49)
        containerViewBottomAnchor?.active = true
        
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
        if !inputTextField.text!.isEmpty {
        let ref = FIRDatabase.database().reference().child("general")
        
        //let childRef = ref.childByAutoId()
        let toId = "general"
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timeStamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toId": toId, "fromId": fromId, "timeStamp": timeStamp]
        let childRef = ref.child(timeStamp.stringValue)
        childRef.updateChildValues(values){(error, ref) in
            if error != nil{
                print(error)
                return
            }
            
            self.inputTextField.text = nil
            
//            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
//            let messageId = childRef.key
//            userMessagesRef.updateChildValues([messageId: 1])
//            
//            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId)
//            recipientUserMessagesRef.updateChildValues([messageId:1])
        }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    
}
