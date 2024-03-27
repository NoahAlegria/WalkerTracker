//
//  FirstViewController.swift
//  walkerTracker
//
//  Created by user144566 on 10/12/18.
//  Copyright © 2018 user144566. All rights reserved.
//

import UIKit
import Material

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var passedIndex : Int?
    let picker = UIImagePickerController()

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var passField: UILabel!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var pharmaField: UILabel!
    @IBOutlet weak var addressField: UILabel!
    @IBOutlet weak var userField: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var pharmButton: UIButton!
    @IBOutlet weak var emailButton : UIButton!
    
    
    var profileModel : ProfileModel = ProfileModel()
    var personProfile : PersonProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten2
        picker.delegate = self
        self.navigationItem.title = "Your Profile"
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.gray.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
        prepareButtons()
        homeButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        homeButton.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        pharmButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        pharmButton.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        emailButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        emailButton.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        if passedIndex != -1 {
            profileModel.fetchRecord()
            personProfile = profileModel.getPersonObject(row: passedIndex!)
            passField.text = personProfile?.passWord
            emailField.text = personProfile?.email
            userField.text = personProfile?.userName
            if personProfile?.favPharmZip != nil {
                pharmaField.text = personProfile?.favPharmZip
            }
            else {
                pharmaField.text = "None"
            }
            if personProfile?.homeAddress != nil {
                addressField.text = personProfile?.homeAddress
            }
            else {
                addressField.text = "None"
            }
            if personProfile?.img != nil {
                let image = UIImage(data: personProfile?.img as! Data)
                profilePic.image = image
            }
        }
        
        let barViewControllers = self.tabBarController?.viewControllers
        let secondTab = barViewControllers![1] as! MapViewController
        secondTab.homeAddress = personProfile?.homeAddress
        secondTab.passedIndex = passedIndex
    }
    @IBAction func editFav(button: UIButton) {
        let alert = UIAlertController(title: "Favorite Pharma Zip", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter New Zip"
        })
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            let newZip = (alert.textFields?.first?.text)!
            if !(newZip.isEmpty) {
                self.profileModel.editFav(row: self.passedIndex!, zip: newZip)
                self.pharmaField.text = newZip
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
         self.present(alert, animated: true)
    }
    
    @objc func changePic(button: UIButton) {
        let alert = UIAlertController(title: "Edit Profile Picture", message: nil, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Use Camera", style: .default, handler: { action in
            
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.picker.allowsEditing = false
                    self.picker.sourceType = UIImagePickerController.SourceType.camera
                    self.picker.cameraCaptureMode = .photo
                    self.picker.modalPresentationStyle = .fullScreen
                    self.present(self.picker,animated: true,completion: nil)
                    
            }
                else {
                    let innerAlert = UIAlertController(title: "No Camera Found", message: nil, preferredStyle: .alert)
                    innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                    self.present(innerAlert, animated: true, completion: nil)
                    print("No Camera Found")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                self.picker.allowsEditing = false
                self.picker.sourceType = .photoLibrary
                self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.picker.modalPresentationStyle = .popover
                self.present(self.picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker .dismiss(animated: true, completion: nil)
        let imageSelected=info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profilePic.image = imageSelected
        profileModel.editPic(row: passedIndex!, img: imageSelected!)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setHome(button: UIButton) {
        
        let alert = UIAlertController(title: "Set Home Address", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Address"
        })
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            let newAddress = (alert.textFields?.first?.text)!
            if !(newAddress.isEmpty) {
                self.profileModel.editAddress(row: self.passedIndex!, address: newAddress)
                self.addressField.text = newAddress
                let barViewControllers = self.tabBarController?.viewControllers
                let secondTab = barViewControllers![1] as! MapViewController
                secondTab.homeAddress = self.personProfile?.homeAddress
            }
            else {
                print("Not Enough Information")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func setEmail(button: UIButton) {
        
        let alert = UIAlertController(title: "Set New Email", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "email"
        })
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            let newAddress = (alert.textFields?.first?.text)!
            if !(newAddress.isEmpty) {
                self.profileModel.editEmail(row: self.passedIndex!, email: newAddress)
                self.emailField.text = newAddress
            }
            else {
                print("Not Enough Information")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "detailView"){
            if let viewController: MapViewController = segue.destination as? MapViewController {
                //viewController.selectedPerson = person.personName;
            }
        }
        else if(segue.identifier == "other") {
            //temp
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        if segue.source is ProfileViewController {
            //sweet
        }
    }
}

extension ProfileViewController {
    
    
    fileprivate func prepareButtons() {
        let button2 = RaisedButton(title: "Edit Profile Picture", titleColor: .white)
        button2.pulseColor = .red
        button2.backgroundColor = Color.blue.base
        button2.addTarget(self, action: #selector(changePic), for: .touchUpInside)
        
        view.layout(button2)
            .width(210)
            .height(ButtonLayout.Raised.height)
            .bottom(100).center()
    }
    
}

