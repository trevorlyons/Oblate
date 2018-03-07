//
//  Image+CoreDataClass.swift
//  
//
//  Created by Trevor Lyons on 2018-03-06.
//
//

import Foundation
import CoreData

@objc(Image)
public class Image: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
}
