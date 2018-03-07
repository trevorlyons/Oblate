//
//  Image+CoreDataProperties.swift
//  
//
//  Created by Trevor Lyons on 2018-03-06.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var type: NSObject?
    @NSManaged public var created: NSDate?
    @NSManaged public var toTitle: Title?

}
