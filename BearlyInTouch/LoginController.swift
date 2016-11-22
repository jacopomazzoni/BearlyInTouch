//
//  LoginController.swift
//  BearlyInTouch
//
//  Created by Carlos Gonzalez on 11/16/16.
//  Copyright © 2016 BearlyInTouch. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseDatabase
import UIKit

let theColor : UIColor = UIColor(red: 172/255, green: 75/255, blue: 87/255, alpha: 1)

class LoginController: UIViewController {
    
    var messagesController: MessageController?
    
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
    }()
    
    func showAlert(message:String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func handleRegister(){
        guard let email = emailTextField.text, password = passwordTextField.text else{
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: {( user:FIRUser?,error) in
            
            if error != nil{
                print(error)
                self.showAlert((error?.localizedDescription)!)
                return
            }
            
            guard let uid = user?.uid else{
                return
            }
            //Succesfully authenticated!
            let ref = FIRDatabase.database().referenceFromURL("https://bearlyintouch-e78b1.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["email": email, "password": password ]
            usersReference.updateChildValues(values,withCompletionBlock: {(err, ref) in
                
                if err != nil{
                    print(err)
                    self.showAlert((err?.localizedDescription)!)
                    return
                }
                
                self.messagesController?.navigationItem.title = values["email"]
                self.dismissViewControllerAnimated(true, completion: nil)
                print("Saved User Succesfully into Firebase")
                
            })
        })
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.secureTextEntry = true
        return tf
    }()
    
    let passwordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    func setupLoginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterButton.topAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor,constant: 12).active = true
        loginRegisterButton.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginRegisterButton.heightAnchor.constraintEqualToConstant(30).active = true
    }
    
    func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    func handleLogin(){
        
        guard let email = emailTextField.text, password = passwordTextField.text else{
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                self.showAlert((error?.localizedDescription)!)
                return
            }
            //Succesfully Logged in
            self.messagesController?.fetchUserandSetNavBarTitle()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func setupProfileImageView(){
        profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        profileImageView.bottomAnchor.constraintEqualToAnchor(loginRegisterSegmentedControl.topAnchor,constant: -12).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(150).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(150).active = true
    }
    
    func setupLoginRegisterSegmentedControl(){
        loginRegisterSegmentedControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterSegmentedControl.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor,constant: -12).active = true
        loginRegisterSegmentedControl.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginRegisterSegmentedControl.heightAnchor.constraintEqualToConstant(36).active = true
        
    }
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.whiteColor()
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), forControlEvents: .ValueChanged)
        
        return sc
    }()
    
    func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegmentAtIndex(loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, forState: .Normal)
        
        //Later on, we might want to add more requirements to the logon:
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = theColor
        //other potential color, pick your favorite:
        //view.backgroundColor = UIColor(red: 75/255, green: 172/255, blue: 160/255, alpha: 1)
        
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }
    
    func setupInputsContainerView(){
        //Constraints
        inputsContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputsContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        inputsContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
        inputsContainerView.heightAnchor.constraintEqualToConstant(100).active = true
        inputsContainerView.addSubview(emailTextField)
        
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordSeparatorView)
        
        //need x,y, width, height constraints
        emailTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor,constant: 12).active = true
        emailTextField.topAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor).active = true
        emailTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor,multiplier: 1/2).active = true
        
        emailSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        emailSeparatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        emailSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        emailSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        passwordTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor,constant: 12).active = true
        passwordTextField.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        passwordTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor,multiplier: 1/2).active = true
        
        passwordSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        passwordSeparatorView.topAnchor.constraintEqualToAnchor(passwordTextField.bottomAnchor).active = true
        passwordSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        passwordSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
