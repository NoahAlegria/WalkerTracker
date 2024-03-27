//
//  WelcomeViewController.swift
//  walkerTracker
//
//  Created by user144566 on 11/11/18.
//  Copyright © 2018 user144566. All rights reserved.
//

import UIKit
import Material

struct ButtonLayout {
    struct Flat {
        static let width: CGFloat = 120
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -150
    }
    
    struct Raised {
        static let width: CGFloat = 300
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -75
    }
}

class WelcomeViewController: UIViewController {
    var profileModel : ProfileModel = ProfileModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCreateNewButton()
        view.backgroundColor = Color.grey.lighten2
        self.navigationItem.title = "Welcome to WalkerTracker"
    }
    
    @objc func createNew(button: RaisedButton) {
        let alert = UIAlertController(title: "Enter User, Password, and Email to Continue", message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "username"
        })
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "password"
            textField.isSecureTextEntry = true
        })
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "email"
        })
        
        alert.addAction(UIAlertAction(title: "Create Account", style: .default, handler: { action in
            let user = (alert.textFields?.first?.text)!
            let pass = (alert.textFields?[1].text)!
            let email = (alert.textFields?.last?.text)!
            if !(user.isEmpty), !(pass.isEmpty), !(email.isEmpty) {
                self.profileModel.fetchRecord()
                if !(self.profileModel.personExists(user: user, pass: pass)) {
                    self.profileModel.addAccount(user: user,pass: pass,email: email)
                    print("UserName: \(user) created")
                    let innerAlert = UIAlertController(title: "Account Created!", message: nil, preferredStyle: .alert)
                    innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                    self.present(innerAlert, animated: true, completion: nil)
                }
                else {
                    let innerAlert = UIAlertController(title: "User Already Exists", message: nil, preferredStyle: .alert)
                    innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                    self.present(innerAlert, animated: true, completion: nil)
                    print("User Already Exists")
                }
            }
            else {
                let innerAlert = UIAlertController(title: "Not Enough Info", message: nil, preferredStyle: .alert)
                innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                self.present(innerAlert, animated: true, completion: nil)
                print("Not Enough Info")
            }
        }))
         alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func gPlus(button: UIButton) {
        let innerAlert = UIAlertController(title: "Just Kidding", message: nil, preferredStyle: .alert)
        innerAlert.addAction(UIAlertAction(title: "Sign in Manually", style: .default, handler:nil))
        self.present(innerAlert, animated: true, completion: nil)
    }
    
    @IBAction func backToWelcome(segue: UIStoryboardSegue) {
        print("Is working")
    }
    
    
    @objc func goToLogin(button: RaisedButton) {
        print("To Login")
        performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = Color.grey.lighten2
    }
}


extension WelcomeViewController {
    
    
    fileprivate func prepareCreateNewButton() {
        let button = RaisedButton(title: "Create New Account", titleColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.blue.base
        button.addTarget(self, action: #selector(createNew), for: .touchUpInside)
        
        view.layout(button)
            .width(ButtonLayout.Raised.width)
            .height(ButtonLayout.Raised.height)
            .center(offsetY: ButtonLayout.Raised.offsetY)
        
        let button2 = RaisedButton(title: "Login With Existing Account", titleColor: .white)
        button2.pulseColor = .white
        button2.backgroundColor = Color.blue.base
        button2.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        
        view.layout(button2)
            .width(ButtonLayout.Raised.width)
            .height(ButtonLayout.Raised.height)
            .center(offsetY: 0)
        
        let button3 = RaisedButton(title: "Login With Google+(lol)", titleColor: .white)
        button3.pulseColor = .white
        button3.backgroundColor = Color.blue.base
        button3.addTarget(self, action: #selector(gPlus), for: .touchUpInside)
        
        view.layout(button3)
            .width(ButtonLayout.Raised.width)
            .height(ButtonLayout.Raised.height)
            .center(offsetY: 75)
        
    }
    
}
