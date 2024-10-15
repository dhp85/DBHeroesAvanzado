//
//  MOLocation+CoreDataClass.swift
//  DBHeroesAvanzado
//
//  Created by Diego Herreros Parron on 15/10/24.
//
//

import Foundation
import CoreData

@objc(MOLocation)
public class MOLocation: NSManagedObject {

}

extension MOLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOLocation> {
        return NSFetchRequest<MOLocation>(entityName: "CDLocation")
    }

    @NSManaged public var id: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var date: String?
    @NSManaged public var hero: MOHero?

}

extension MOLocation : Identifiable {

}
