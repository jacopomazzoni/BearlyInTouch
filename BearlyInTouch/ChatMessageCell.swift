//
//  ChatMessageCell.swift
//  BearlyInTouch
//
//  Created by Jee  on 12/4/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Sample Text"
        tv.font = UIFont.systemFontOfSize(16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clearColor()
        tv.textColor = UIColor.whiteColor()
        return tv
    }()
    
    static let blueColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 0.6)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    
    override init (frame: CGRect){
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        
        bubbleRightAnchor = bubbleView.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -8)
        
        bubbleRightAnchor?.active = true
        
        bubbleLeftAnchor = bubbleView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8)
        
        
        bubbleView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraintEqualToConstant(200)
        bubbleWidthAnchor?.active = true
        bubbleView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
        textView.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor, constant: 8).active = true
        textView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        //textView.widthAnchor.constraintEqualToConstant(200).active = true
        
        textView.rightAnchor.constraintEqualToAnchor(bubbleView.rightAnchor).active = true
        
        textView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
