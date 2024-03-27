//
//  LoginViewController.swift
//  walkerTracker
//
//  Created by user144566 on 11/11/18.
//  Copyright © 2018 user144566. All rights reserved.
//

import UIKit
import Material
import FontAwesome_swift

class LoginViewController: UIViewController {

    fileprivate var userField: TextField!
    fileprivate var passwordField: TextField!
    var index : Int?
    var profileModel : ProfileModel = ProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        view.backgroundColor = Color.grey.lighten2
        self.navigationItem.title = "Login Page"
        prepareLoginButton()
        preparePasswordField()
        prepareUsernameField()
    }
    
    @objc func login(button: UIButton) {
        let user = userField.text
        let pass = passwordField.text
        if !(user!.isEmpty), !(pass!.isEmpty) {
            profileModel.fetchRecord()
            index = profileModel.locatePersonProfile(user: user!, pass: pass!)
            if index != -1 {
                performSegue(withIdentifier: "toTabbed", sender: nil)
            }
            else {
                let innerAlert = UIAlertController(title: "Profile Not Found", message: nil, preferredStyle: .alert)
                innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                self.present(innerAlert, animated: true, completion: nil)
                print("Profile Not Found")
            }
        }
        else {
            let innerAlert = UIAlertController(title: "Incomplete Info", message: nil, preferredStyle: .alert)
            innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            self.present(innerAlert, animated: true, completion: nil)
            print("Incomplete Info")
        }
    }
    
    fileprivate func prepareLoginButton() {
        let btn = RaisedButton(title: "Login", titleColor: .white)
        btn.backgroundColor = Color.blue.base
        btn.pulseColor = .white
        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        view.layout(btn).width(100).height(32).center(offsetY: -10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toTabbed"){
            if let barViewController: UITabBarController = segue.destination as? UITabBarController {
                let nav = barViewController.viewControllers![0] as! ProfileViewController
                //let destinationViewController = nav.topViewController as! ProfileViewController
                nav.passedIndex = index
                print("Login Success. Index: \(index)")
                
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = Color.grey.lighten2
    }
}

extension LoginViewController {
    fileprivate func prepareUsernameField() {
        userField = TextField()
        userField.placeholder = "username"
        userField.detail = "Enter Username Here"
        userField.isClearIconButtonEnabled = true
        userField.placeholderAnimation = .hidden
        userField.autocapitalizationType = .none
        
        // Set the colors for the emailField, different from the defaults.
                userField.placeholderNormalColor = Color.grey.base
                userField.placeholderActiveColor = Color.blue.base
                userField.dividerNormalColor = Color.cyan.base
                userField.dividerActiveColor = Color.blue.base
        
        let leftView = UIImageView()
        leftView.image = UIImage.fontAwesomeIcon(name: .user, style: .regular, textColor: Color.grey.base, size: CGSize(width: 30, height: 30))
        userField.leftView = leftView
        
        view.layout(userField).center(offsetY: -passwordField.bounds.height - 150).left(20).right(20)
    }
    
    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "password"
        passwordField.detail = "At least 6 characters"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        passwordField.placeholderAnimation = .hidden
        
        passwordField.placeholderNormalColor = Color.grey.base
        passwordField.placeholderActiveColor = Color.blue.base
        passwordField.dividerNormalColor = Color.cyan.base
        passwordField.dividerActiveColor = Color.blue.base
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        let leftView = UIImageView()
        leftView.image = UIImage.fontAwesomeIcon(name: .key, style: .solid, textColor: Color.grey.base, size: CGSize(width: 30, height: 30))
        passwordField.leftView = leftView
        
        view.layout(passwordField).center(offsetY: -100).left(20).right(20)
    }
}
