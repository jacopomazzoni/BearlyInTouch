//
//  ChatInputContainerView.swift
//  BearlyInTouch
//
//  Created by super on 12/7/16. Ep 23 min12
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit

class ChatInputContainerView: UIView {
    
    var separatorLineView : UIView = {
        let Line = UIView()
        Line.backgroundColor = UIColor.blackColor()
        Line.translatesAutoresizingMaskIntoConstraints = false
        return Line
    }()
    
    
    var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        //textField.delegate = self
        return textField
    }()
    
    var sendButton : UIButton = {
        let sButton = UIButton(type: .System)
        sButton.setTitle("Send", forState: .Normal)
        sButton.translatesAutoresizingMaskIntoConstraints = false
        //sButton.addTarget(self, action: #selector(handleSend), forControlEvents: .TouchUpInside)
        return sButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraintEqualToConstant(50).active = true
        
        
        addSubview(sendButton)
        //sendButton constraints
        sendButton.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
        sendButton.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        sendButton.widthAnchor.constraintEqualToConstant(80).active = true
        sendButton.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
        

        addSubview(inputTextField)
        //textfield constraints
        inputTextField.leftAnchor.constraintEqualToAnchor(leftAnchor, constant: 8).active = true
        inputTextField.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        inputTextField.rightAnchor.constraintEqualToAnchor(sendButton.leftAnchor).active = true
        inputTextField.heightAnchor.constraintEqualToAnchor(heightAnchor).active = true
        
        addSubview(separatorLineView)
        //Separator constraints
        separatorLineView.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
        separatorLineView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        separatorLineView.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
        separatorLineView.heightAnchor.constraintEqualToConstant(1).active = true
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
