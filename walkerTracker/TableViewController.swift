//
//  TableViewController.swift
//  walkerTracker
//
//  Created by user144566 on 11/14/18.
//  Copyright © 2018 user144566. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Material

class TableViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    var json : NSArray?
    var parsedJson : NSDictionary?
    var passedIndex : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // get the section count
        return json!.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PharmaTableViewCell
        self.parsedJson = json![indexPath.section] as! NSDictionary
        
        //cell.addressHeader.font = UIFont.fontAwesome(ofSize: 100, style: .brands)
        
        // build each each row for section
        cell.addressField.text = parsedJson!["stadd"] as! String
        var hours = parsedJson!["storeOpenTime"] as! String
        hours += "-"
        hours += parsedJson!["storeCloseTime"] as! String
        cell.hoursField.text = hours
        var eta = parsedJson!["stdist"] as! String
        eta += " mi."
        cell.etaField.text = eta
        cell.addressPic.image = UIImage.fontAwesomeIcon(name: .home, style: .solid, textColor: Color.blue.base, size: CGSize(width: 30, height: 30))
        cell.hoursPic.image = UIImage.fontAwesomeIcon(name: .clock, style: .solid, textColor: Color.blue.base, size: CGSize(width: 30, height: 30))
        cell.etaPic.image = UIImage.fontAwesomeIcon(name: .running, style: .solid, textColor: Color.blue.base, size: CGSize(width: 30, height: 30))
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        table.rowHeight = 85
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Being called")
        let selectedIndex: IndexPath = self.table.indexPath(for: sender as! UITableViewCell)!
        
        let currPharm = json![selectedIndex.row] as! NSDictionary
        print(currPharm)
        
        if(segue.identifier == "toDetail"){
            print("in here")
            if let viewController: DetailViewController = segue.destination as? DetailViewController {
                viewController.passedStore = currPharm
                viewController.passedIndex = passedIndex
                print("also here")
            }
        }
    }
    
    
    @IBAction func dismissButton(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
}
