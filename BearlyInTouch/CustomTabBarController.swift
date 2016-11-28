//
//  Item1ViewController.swift
//  BearlyInTouch
//
//  Created by Carlos Gonzalez on 11/22/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseDatabase
import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let messageController = UINavigationController(rootViewController: MessageController())
        messageController.tabBarItem.title = "General"
        messageController.tabBarItem.image = UIImage(named: "mainGroup")
        
//        let viewController  = UIViewController()
//        let matchController = UINavigationController(rootViewController: viewController)
//        matchController.tabBarItem.title = "Match"
        
//        let pastMatchController = UINavigationController(rootViewController: viewController)
//        pastMatchController.tabBarItem.title = "Past Match"
//        
//        let settingsController = UINavigationController(rootViewController: viewController)
//        settingsController.tabBarItem.title = "Settings"

        viewControllers = [messageController,createDummyNavControllerWithTitle("Match",image: "match"),createDummyNavControllerWithTitle("Past Match",image: "messages"),createDummyNavControllerWithTitle("Settings",image: "settings")]
    
    }
    
    private func createDummyNavControllerWithTitle(title: String, image: String) -> UINavigationController{
        let viewController  = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: image)
        return navController
    }
    
    
    
}