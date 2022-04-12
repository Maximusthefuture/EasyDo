//
//  Task+CoreDataProperties.swift
//  EasyDo
//
//  Created by Maximus on 12.04.2022.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var dueDate: Date?
    @NSManaged public var mainTag: String?
    @NSManaged public var pomodoroCount: Int16
    @NSManaged public var tags: [String]?
    @NSManaged public var taskDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var project: Project?
    @NSManaged public var attachments: Attachments?

}

extension Task : Identifiable {

}
