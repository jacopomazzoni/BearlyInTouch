//
//  ProfileImageCell.swift
//  BearlyInTouch
//
//  Created by super on 12/4/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import UIKit


class ProfileImageCell : UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        
        let IMGsize :CGFloat = 90
        //profileImageView Constraints: x,y,width,height anchors
        profileImageView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        //profileImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor,constant: 8).active = true
        profileImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(IMGsize).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(IMGsize).active = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


