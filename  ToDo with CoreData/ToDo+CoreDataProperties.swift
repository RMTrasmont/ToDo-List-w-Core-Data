//
//  ToDo+CoreDataProperties.swift
//   CoreData
//
//  Created by Rafael M. Trasmontero on 1/5/18.
//  Copyright © 2018 GTTuts. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var title: String?
    @NSManaged public var priority: Int16
    @NSManaged public var date: NSDate?

}
