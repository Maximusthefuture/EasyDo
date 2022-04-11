//
//  WeeklyGoal+CoreDataProperties.swift
//  EasyDo
//
//  Created by Maximus on 11.04.2022.
//
//

import Foundation
import CoreData


extension WeeklyGoal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeeklyGoal> {
        return NSFetchRequest<WeeklyGoal>(entityName: "WeeklyGoal")
    }

    @NSManaged public var title: String?
    @NSManaged public var goalDescription: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?

}

extension WeeklyGoal : Identifiable {

}
