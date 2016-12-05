//
//  UserCell.swift
//  BearlyInTouch
//
//  Created by super on 12/3/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserCell : UITableViewCell {
    
    var message : Message? {
        didSet {
            
            setupName()
            
            //text label for the messages
            detailTextLabel?.text = message?.text
           
            
            if let seconds = message?.timeStamp?.doubleValue{
                let timeStampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeLabel.text = dateFormatter.stringFromDate(timeStampDate)
            }
            
            
        }
    }
    
    private func setupName() {
        if let id = message?.chatPartnerId(){
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observeEventType(.Value, withBlock: {
                (snapshot) in
                
                
                
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    self.textLabel?.text = dictionary["email"] as? String
                    self.textLabel?.font = UIFont.boldSystemFontOfSize(16)
                }
                }, withCancelBlock: nil)
            
        }
    }
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.lightGrayColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRectMake(64, textLabel!.frame.origin.y - 2, textLabel!.frame.width, textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRectMake(64, detailTextLabel!.frame.origin.y + 2, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
    }
 
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bear")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    
 
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(profileImageView)
        self.addSubview(timeLabel)

        //profileImageView Constraints: x,y,width,height anchors
        profileImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor,constant: 8).active = true
        profileImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(48).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(48).active = true
        
        
        // timeLabel Constraints: x,y,width,height anchors
        timeLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        timeLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 20).active = true
        timeLabel.widthAnchor.constraintEqualToConstant(100).active = true
        timeLabel.heightAnchor.constraintEqualToAnchor(textLabel?.heightAnchor).active = true
        

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

