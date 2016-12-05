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

//Wehn re-running the app, the tableviews are appended twice but gone upon switching back and forth from a different tab


class SettingsController: UITableViewController {
    
    var settingsView = [UITableViewCell]()
    var userEmail = String()
    var userFirstName = String();
    var userLastName = String();
    var status = String();
    var major = String();
    
    let profileImageView : UIImageView = {
        print("sajin shibal")
        let xOffset: CGFloat = 10
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bear")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.frame = CGRectMake(CGFloat(145), CGFloat(-10), CGFloat(80), CGFloat(80))
        return imageView
    }()
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        self.settingsView = [UITableViewCell]()
        // Add navbar Title
        navigationItem.title = "Settings"
        
        // Load User Email and array of cells
        self.fetchUserAndPopulate()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.settingsView = [UITableViewCell]() //possible error by appending too many into the array?
        
        viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settingsView.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return ( settingsView[indexPath.row] )
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height : CGFloat = 60
        if settingsView[indexPath.row].reuseIdentifier == "spacer"
        {
            height = 30
        }
        else if settingsView[indexPath.row].reuseIdentifier == "image"
        {
            height = 100
        }
        
        return height
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
            let cell = ProfileImageCell(style: UITableViewCellStyle.Default , reuseIdentifier: "image")
            
                //UITableViewCell(style: .Default, reuseIdentifier: "image")
            //cell.contentView.addSubview(profileImageView)
            //cell.contentView.alignmentRectForFrame(profileImageView.frame)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "fname")
            cell.textLabel?.text = "Full Name"
            cell.detailTextLabel?.text = userFirstName + " " + userLastName
            cell.textLabel?.textAlignment = .Left
            
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "email")
            cell.textLabel?.text = "Email"
            cell.detailTextLabel?.text = self.userEmail
            cell.textLabel?.textAlignment = .Left
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "affiliation")
            cell.textLabel?.text = "Status"
            cell.detailTextLabel?.text = self.status
            cell.textLabel?.textAlignment = .Center
            return cell }())
        
        settingsView.append( {
            let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "major")
            cell.textLabel?.text = "Major/Area of Study"
            cell.detailTextLabel?.text = self.major
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
            cell.textLabel?.textAlignment = .Center
            return cell }())
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let id = indexPath.row
        switch id {
        case 3:
            print(" tapped on \(id)")
        case 4:
            print(" tapped on \(id)")
        case 5:
            print(" tapped on \(id)")
        case 7:
            self.handleLogout()
        default:
            print("Error, \(id) not handled")
        }
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        // define array of index of editable elements
        let elements = [2,4,5]
        
        if elements.contains(indexPath.row)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit"){ (rowAction, indexPath) in
            print("edit action")
            self.displayShareSheet(indexPath)
        }
        return [editAction]
        
        
    }
    
    func displayShareSheet(indexPath: NSIndexPath)
    {
       
        
        if(indexPath.row == 2){
            var nameFirst = ""
            var nameLast = ""
            
            
            let alertController = UIAlertController(title: "Edit Name", message: "Enter Your Name", preferredStyle: .Alert)
            
            
            alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
                textField.placeholder = "First Name"
            }
            
            alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
                textField.placeholder = "Last Name"
            }
            
            let submit = UIAlertAction(title: "Submit", style: .Default, handler: { (action) -> Void in
            
            let firstName = alertController.textFields![0] as UITextField
            let lastName = alertController.textFields![1] as UITextField
                
                let uid = Mydb.auth?.currentUser?.uid
                let ref = Mydb.db!.reference()
            let userReference = ref.child("users").child(uid!)
            
            nameFirst = firstName.text!
            nameLast = lastName.text!
           
             
                let childUpdates = ["nameFirst": nameFirst, "nameLast": nameLast]
                userReference.updateChildValues(childUpdates)
            
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            })
            
            alertController.addAction(submit)
            alertController.addAction(cancel)
            
            self.navigationController!.presentViewController(alertController, animated: true, completion: nil)
        }
            
        else if(indexPath.row == 4){
            let alertController = UIAlertController(title: "Edit Status", message: "Choose one of the Following", preferredStyle: .ActionSheet)
            
            let undergraduate = UIAlertAction(title: "Undergraduate", style: .Default, handler: { (action) -> Void in
                let uid = Mydb.auth?.currentUser?.uid
                let ref = Mydb.db!.reference()
                
                let userReference = ref.child("users").child(uid!)
                
                self.status = "Undergraduate"
                
                let childUpdates = ["status": self.status]
                userReference.updateChildValues(childUpdates)

            })
            
            let graduate = UIAlertAction(title: "Graduate", style: .Default, handler: { (action) -> Void in
                let uid = Mydb.auth?.currentUser?.uid
                let ref = Mydb.db!.reference()
                let userReference = ref.child("users").child(uid!)
                
                self.status = "Graduate"
                
                let childUpdates = ["status": self.status]
                userReference.updateChildValues(childUpdates)
            })
            
            let faculty = UIAlertAction(title: "Faculty/Staff", style: .Default, handler: { (action) -> Void in
                
                let uid = Mydb.auth?.currentUser?.uid
                let ref = Mydb.db!.reference()
                let userReference = ref.child("users").child(uid!)
                
                self.status = "Faculty/Staff"
                
                let childUpdates = ["status": self.status]
                userReference.updateChildValues(childUpdates)
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            
                //print("Send now button tapped for value \(self.itemsToLoad[indexPath.row])")
            })
            
            alertController.addAction(undergraduate)
            alertController.addAction(graduate)
            alertController.addAction(faculty)
            alertController.addAction(cancel)
            
            self.navigationController!.presentViewController(alertController, animated: true, completion: nil)
        }
            
        else if(indexPath.row == 5){
            
            let alertController = UIAlertController(title: "Edit Major/Area of Study", message: "Enter Your Major/Area of Study", preferredStyle: .Alert)
            
            alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
                textField.placeholder = "Major/Area of Study"
            }
            
            let submit = UIAlertAction(title: "Submit", style: .Default, handler: { (action) -> Void in
            
                let majorField = alertController.textFields![0] as UITextField
                
                let uid = FIRAuth.auth()?.currentUser?.uid
                let ref = FIRDatabase.database().referenceFromURL("https://bearlyintouch-e78b1.firebaseio.com/")
                let userReference = ref.child("users").child(uid!)
                
                self.major = majorField.text!
               
                
                
                let childUpdates = ["major": self.major]
                userReference.updateChildValues(childUpdates)
                

                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                //print("Send now button tapped for value \(self.itemsToLoad[indexPath.row])")
            })
            
            alertController.addAction(submit)
            alertController.addAction(cancel)
            
            self.navigationController!.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    
    
    
    func handleLogout(){
        print("in 1")
        do{
            try Mydb.auth?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
        print("in 2")
        let loginController = LoginController()
        loginController.messagesController = nil
        Mydb = FirebaseHelper()
        presentViewController(loginController, animated: true, completion: nil)
    }
    
    func fetchUserAndPopulate()
    {
        var value : String = ""
        guard let uid = Mydb.auth?.currentUser?.uid else
        { return }
        
        Mydb.db!.reference().child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                value = (dictionary["email"] as? String)!
                self.userFirstName = (dictionary["nameFirst"] as? String)!
                self.userLastName = (dictionary["nameLast"] as? String)!
                self.status = (dictionary["status"] as? String)!
                self.major = (dictionary["major"] as? String)!
                self.userEmail = value
                self.populateSV()
                self.tableView.reloadData()
            }
            }, withCancelBlock: nil )
    }
    
    
}
