//
//  navExt.swift
//  BearlyInTouch
//
//  Created by super on 12/3/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    

    
    public func test() {
        
        // set background color to theme color and get rid of gradient
        if let navBackgroundImage:UIImage! = UIImage(color: theColor) {
            UINavigationBar.appearance().setBackgroundImage(navBackgroundImage, forBarMetrics: .Default)
        }
        
        // tint buttons
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
         
        let navbarFont =  UIFont.systemFontOfSize(20)
        //let barbuttonFont = UIFont.systemFontOfSize(20)
        
        // Set 
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: navbarFont, NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        /*UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: barbuttonFont, NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)
         */
    }
    
    /*
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
        navigationBar.translucent = true
        navigationBar.shadowImage = UIImage()
        setNavigationBarHidden(false, animated:true)
    }
    
    public func hideTransparentNavigationBar() {
        setNavigationBarHidden(true, animated:false)
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImageForBarMetrics(UIBarMetrics.Default), forBarMetrics:UIBarMetrics.Default)
        navigationBar.translucent = UINavigationBar.appearance().translucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }*/
}