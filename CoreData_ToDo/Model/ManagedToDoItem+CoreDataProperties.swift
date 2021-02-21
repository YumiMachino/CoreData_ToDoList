//
//  ManagedToDoItem+CoreDataProperties.swift
//  CoreData_ToDo
//
//  Created by Yumi Machino on 2021/02/21.
//
//

import Foundation
import CoreData


extension ManagedToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedToDoItem> {
        return NSFetchRequest<ManagedToDoItem>(entityName: "ManagedToDoItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var isCompletedIndicator: Bool
    @NSManaged public var priorityLevel: Int16

}

extension ManagedToDoItem : Identifiable {

}
