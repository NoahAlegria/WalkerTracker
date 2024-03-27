//
//  DetailViewController.swift
//  walkerTracker
//
//  Created by user144566 on 11/14/18.
//  Copyright © 2018 user144566. All rights reserved.
//

import UIKit
import Material
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var addressField: UILabel!
    @IBOutlet weak var hoursField: UILabel!
    @IBOutlet weak var phoneField: UILabel!
    @IBOutlet weak var hasPharm: UILabel!
    @IBOutlet weak var pharmHours: UILabel!
    
    var passedStore : NSDictionary?
    var passedIndex : Int?
    var profileModel : ProfileModel = ProfileModel()
    var personProfile : PersonProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareButtons()
        view.backgroundColor = Color.grey.lighten2
        
        if passedIndex != -1 {
            profileModel.fetchRecord()
            personProfile = profileModel.getPersonObject(row: passedIndex!)
        }
        if passedStore != nil {
            addressField.text = passedStore!["stadd"] as! String
            hoursField.text = passedStore!["storeCloseTime"] as! String
            phoneField.text = passedStore!["stph"] as! String
            hasPharm.text = passedStore!["pharmacyStatus"] as! String
            pharmHours.text = passedStore!["pharmacyCloseTime"] as! String
            
        }
    }
    @objc func newFav(button: UIButton) {
        let newZip = passedStore!["stzp"] as! String
        self.profileModel.editFav(row: self.passedIndex!, zip: newZip)
        let innerAlert = UIAlertController(title: "New Favorite Added", message: nil, preferredStyle: .alert)
        innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
        self.present(innerAlert, animated: true, completion: nil)
    }
    
    @objc func openBrowser(button: UIButton) {
        performSegue(withIdentifier: "toWeb", sender: nil)
    }
    
    
}

extension DetailViewController {
    
    
    fileprivate func prepareButtons() {
        let button = RaisedButton(title: "Add New Favorite", titleColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.blue.base
        button.addTarget(self, action: #selector(newFav), for: .touchUpInside)
        
        view.layout(button)
            .width(200)
            .height(35)
            .bottom(130).center()
        
        let button2 = RaisedButton(title: "Visit Website", titleColor: .white)
        button2.pulseColor = .white
        button2.backgroundColor = Color.blue.base
        button2.addTarget(self, action: #selector(openBrowser), for: .touchUpInside)
        
        view.layout(button2)
            .width(200)
            .height(35)
            .bottom(80).center()
        
    }
    
}

