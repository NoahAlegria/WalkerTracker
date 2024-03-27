//
//  PersonProfile+CoreDataProperties.swift
//  walkerTracker
//
//  Created by user144566 on 11/12/18.
//  Copyright © 2018 user144566. All rights reserved.
//
//

import Foundation
import CoreData


extension PersonProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonProfile> {
        return NSFetchRequest<PersonProfile>(entityName: "PersonProfile")
    }

    @NSManaged public var email: String?
    @NSManaged public var favPharmLat: String?
    @NSManaged public var favPharmLong: String?
    @NSManaged public var favPharmZip: String?
    @NSManaged public var img: NSData?
    @NSManaged public var passWord: String?
    @NSManaged public var userName: String?
    @NSManaged public var homeAddress: String?

}
