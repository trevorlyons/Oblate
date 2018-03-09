//
//  Setting+CoreDataProperties.swift
//  
//
//  Created by Trevor Lyons on 2018-03-08.
//
//

import Foundation
import CoreData


extension Setting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Setting> {
        return NSFetchRequest<Setting>(entityName: "Setting")
    }

    @NSManaged public var flash: String?
    @NSManaged public var language: Int16

}
