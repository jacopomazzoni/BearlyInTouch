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
        
        let messageController : UINavigationController = {
            let nav = UINavigationController(rootViewController: MessageController())
            nav.test()
            nav.tabBarItem.title = "General"
            nav.tabBarItem.image = UIImage(named: "mainGroup")
            return nav
        }()
        
        let matchController : UINavigationController = {
            
            let chatLogController = MatchingController(collectionViewLayout: UICollectionViewFlowLayout())
            let nav = UINavigationController(rootViewController: chatLogController)
            nav.tabBarItem.title = "Match"
            nav.tabBarItem.image = UIImage(named: "match")
            return nav
        }()
        
        let messagesController : UINavigationController = {

            return createDummyNavControllerWithTitle("Messages",image: "messages")
        }()
        
        let settingsController : UINavigationController = {
            let nav = UINavigationController(rootViewController: SettingsController())
            nav.tabBarItem.title = "Settings"
            nav.tabBarItem.image = UIImage(named: "settings")
            return nav
        }()
        
        //        let viewController  = UIViewController()
        //        let matchController = UINavigationController(rootViewController: viewController)
        //        matchController.tabBarItem.title = "Match"
        
        //        let pastMatchController = UINavigationController(rootViewController: viewController)
        //        pastMatchController.tabBarItem.title = "Past Match"
        //
        //        let settingsController = UINavigationController(rootViewController: viewController)
        //        settingsController.tabBarItem.title = "Settings"
        
        viewControllers = [messageController,matchController,messagesController,settingsController]
    
    }
    
    private func createDummyNavControllerWithTitle(title: String, image: String) -> UINavigationController{
        let viewController  = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: image)
        return navController
    }
    
    
    
}