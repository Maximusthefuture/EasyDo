//
//  Attachments+CoreDataProperties.swift
//  EasyDo
//
//  Created by Maximus on 12.04.2022.
//
//

import Foundation
import CoreData


extension Attachments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attachments> {
        return NSFetchRequest<Attachments>(entityName: "Attachments")
    }

    @NSManaged public var images: [Data]?
    @NSManaged public var files: [Data]?
    @NSManaged public var task: Task?

}

extension Attachments : Identifiable {

}
