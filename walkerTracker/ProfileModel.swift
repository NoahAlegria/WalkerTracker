//
//  ProfileModel.swift
//  walkerTracker
//
//  Created by user144566 on 11/11/18.
//  Copyright © 2018 user144566. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class ProfileModel {
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var   fetchResults =   [PersonProfile]()
    
    func fetchRecord() -> Int {
        // Create a new fetch request using the FruitEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonProfile")
        var x   = 0
        // Execute the fetch request, and cast the results to an array of PersonProfile objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [PersonProfile])!
        
        print(fetchResults)
        
        x = fetchResults.count
        
        print(x)
        
        // return howmany entities in the coreData
        return x
        
        
    }
    
    func addAccount(user: String, pass: String, email: String)
    {
        // create a new entity object
        let ent = NSEntityDescription.entity(forEntityName: "PersonProfile", in: self.managedObjectContext)
        //add to the manege object context
        let newPerson = PersonProfile(entity: ent!, insertInto: self.managedObjectContext)
        newPerson.userName = user
        newPerson.passWord = pass
        newPerson.email = email
        
        // save the updated context
        do {
            try self.managedObjectContext.save()
        } catch _ {
        }
        
        print(newPerson)
    }
    
    func removeAccount(row:Int)
    {
        managedObjectContext.delete(fetchResults[row])
        // remove it from the fetch results array
        fetchResults.remove(at:row)
        
        do {
            // save the updated managed object context
            try managedObjectContext.save()
        } catch {
            
        }
        
    }
    
    func personExists(user: String, pass: String) -> Bool
    {
        for i in 0..<fetchResults.count {
            if  fetchResults[i].userName == user && fetchResults[i].passWord == pass {
                return true
            }
        }
        return false
    }
    func locatePersonProfile(user: String, pass: String) -> Int
    {
        for i in 0 ..< fetchResults.count {
            if  fetchResults[i].userName == user && fetchResults[i].passWord == pass {
                return i
            }
        }
        return -1
    }

    func getPersonObject(row:Int) -> PersonProfile
    {
        return fetchResults[row]
    }
    
    func editFav(row: Int, zip: String) {
        fetchResults[row].setValue(zip, forKey: "favPharmZip")
        do {
            try managedObjectContext.save()
        }
        catch let _ as NSError {
            //handle it
        }
    }
    
    func editEmail(row: Int, email: String) {
        fetchResults[row].setValue(email, forKey: "email")
        do {
            try managedObjectContext.save()
        }
        catch let _ as NSError {
            //handle it
        }
    }
    
    func editPic(row: Int, img: UIImage) {
        let data = img.jpegData(compressionQuality: 1) as? NSData
        fetchResults[row].setValue(data, forKey: "img")
        do {
            try managedObjectContext.save()
        }
        catch let _ as NSError {
            //handle
        }
    }
    
    func editAddress(row: Int, address: String) {
        fetchResults[row].setValue(address, forKey: "homeAddress")
        do {
            try managedObjectContext.save()
        }
        catch let _ as NSError {
            //handle
        }
    }
    
    func deleteAll()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonProfile")
        
        // whole fetchRequest object is removed from the managed object context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(deleteRequest)
            try managedObjectContext.save()
            
            
        }
        catch let _ as NSError {
            // Handle error
        }
        
    }
    
}
