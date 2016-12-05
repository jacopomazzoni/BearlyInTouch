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
    var userEmail = String()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bear")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()

        // Add navbar Title
        navigationItem.title = "Settings"
        
        // Load User Email and array of cells
        self.fetchUserAndPopulate()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settingsView.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return ( settingsView[indexPath.row] )
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        return (settingsView[indexPath.row].reuseIdentifier == "spacer" ? 30 : 60)
    }

    
    func populateSV(){
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "title")
            cell.textLabel?.text = "Profile"
            cell.textLabel?.font = cell.textLabel?.font.fontWithSize(30)
            cell.detailTextLabel?.text = ""
            cell.textLabel?.textAlignment = .Center
            cell.selectionStyle = UITableViewCellSelectionStyle.None
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

            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "email")
            cell.textLabel?.text = "Email"
            cell.detailTextLabel?.text = self.userEmail
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
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "social1")
            cell.textLabel?.text = "Facebook"
            cell.detailTextLabel?.text = "Connect"
            cell.textLabel?.textAlignment = .Center
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "spacer")
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "logout")
            cell.textLabel?.text = "Logout"
            cell.detailTextLabel?.text = self.userEmail
            print(self.userEmail)
            print ("Jacopo")
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
        case 7:
            print(" tapped on \(id)")
        case 9:
            self.handleLogout()
        default:
            print("Error, \(id) not handled")
        }
    }
    
    var messageController: MessageController?
    
    func handleLogout(){
        messageController?.handleLogout()
        
    }
    
    func fetchUserAndPopulate()
    {
        var value : String = ""
        guard let uid = FIRAuth.auth()?.currentUser?.uid else
        { return }
        //FIXME: ADD QUERY THAT CALS FOR USER NAME AND Personal Message AND IMAGE
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                value = (dictionary["email"] as? String)!
                self.userEmail = value
                self.populateSV()
                self.tableView.reloadData()
            }
            }, withCancelBlock: nil )
    }
   
    
}


