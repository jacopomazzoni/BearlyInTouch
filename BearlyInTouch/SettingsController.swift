//
//  SettingsController.swift
//  BearlyInTouch
//
//  Created by super on 12/2/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

//GLOBALS


class SettingsController: UITableViewController {
    
    var settingsView = [UITableViewCell]()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bear")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add navbar Title
        navigationItem.title = "Settings"
        self.populateSV()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsView.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //FIXME : SAFEUNWRAP?
        return ( settingsView[indexPath.row] )
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (settingsView[indexPath.row].reuseIdentifier == "spacer")
        {
            return 30
        }
        else
        {
            return 60
        }
        
    }
    
    lazy var test: UIButton = {
        let button = UIButton(type: .System)
        //button.backgroundColor = UIColor.whiteColor()
        //UIColor(r: 244, g: 72, b: 66 )
        button.setTitle("change", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        //button.translatesAutoresizingMaskIntoConstraints = false
        //button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        //button.layer.cornerRadius = 5
        //button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
        //button.setTitleColor(theColor, forState: .Normal)
        return button
    }()

    
    func populateSV(){
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "title")
            cell.textLabel?.text = "Profile"
            cell.detailTextLabel?.text = ""
            cell.textLabel?.textAlignment = .Center
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "image")
            cell.imageView!.image = profileImageView.image
            cell.imageView
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "fname")
            cell.textLabel?.text = "Full Name"
            cell.detailTextLabel?.text = "Load user Name here"
            cell.textLabel?.textAlignment = .Left
            
            cell.addSubview(test)
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "email")
            cell.textLabel?.text = "Email"
            cell.detailTextLabel?.text = "Load user Email here"
            cell.textLabel?.textAlignment = .Left
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "affiliation")
            cell.textLabel?.text = "Undergrad Grad Faculty"
            cell.detailTextLabel?.text = "Maybe Change to Collectionview"
            cell.textLabel?.textAlignment = .Center
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "major")
            cell.textLabel?.text = "Major/Area of Study"
            cell.detailTextLabel?.text = "load Major"
            cell.textLabel?.textAlignment = .Center
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "spacer")
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "social1")
            cell.textLabel?.text = "Facebook"
            cell.detailTextLabel?.text = "Connect"
            cell.textLabel?.textAlignment = .Center
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "spacer")
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "logout")
            cell.textLabel?.text = "Logout"
            cell.detailTextLabel?.text = "email"
            cell.textLabel?.textAlignment = .Center
            return cell }())
    }
    
    func changeName()
    {
        print("change Name")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let id = indexPath.row
        switch id {
        case 2:
            self.changeName()
        case 3:
            print(" tapped on \(id)")
        case 4:
            print(" tapped on \(id)")
        case 5:
            print(" tapped on \(id)")
        case 9:
            self.handleLogout()
        default:
            print("Error, \(id) not handled")
        }
    }
    
    func handleLogout(){
        
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        loginController.messagesController = nil
        presentViewController(loginController, animated: true, completion: nil)
    }
    
    
}



class CustomCell: UITableViewCell {
    var cellButton: UIButton!
    var cellLabel: UILabel!
    
    init(frame: CGRect, title: String) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        cellLabel = UILabel(frame: CGRectMake(self.frame.width - 100, 10, 100.0, 40))
        cellLabel.textColor = UIColor.blackColor()
        //cellLabel.font = //set font here
            
        cellButton = UIButton(frame: CGRectMake(200, 10, 100, 30))
        cellButton.setTitle(title, forState: UIControlState.Normal)
        cellButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        addSubview(cellLabel)
        addSubview(cellButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}

/*
 let inputsContainerView : UIView = {
 let view = UIView()
 view.backgroundColor = UIColor.whiteColor()
 view.translatesAutoresizingMaskIntoConstraints = false
 view.layer.cornerRadius = 10
 view.layer.masksToBounds = true
 return view
 }()
 
 let profileImageView :UIImageView = {
 let imageView = UIImageView()
 imageView.image = UIImage(named: "bear")
 imageView.translatesAutoresizingMaskIntoConstraints = false
 return imageView
 }()
 lazy var loginRegisterButton: UIButton = {
 let button = UIButton(type: .System)
 button.backgroundColor = UIColor.whiteColor()
 //UIColor(r: 244, g: 72, b: 66 )
 button.setTitle("Register", forState: .Normal)
 button.translatesAutoresizingMaskIntoConstraints = false
 button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
 button.layer.cornerRadius = 5
 button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
 button.setTitleColor(theColor, forState: .Normal)
 return button
 }()*/