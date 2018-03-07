//
//  Title+CoreDataProperties.swift
//  
//
//  Created by Trevor Lyons on 2018-03-06.
//
//

import Foundation
import CoreData


extension Title {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Title> {
        return NSFetchRequest<Title>(entityName: "Title")
    }

    @NSManaged public var inputLanguage: String?
    @NSManaged public var outputLanguage: String?
    @NSManaged public var outputSelector: String?
    @NSManaged public var toImage: Image?

}
