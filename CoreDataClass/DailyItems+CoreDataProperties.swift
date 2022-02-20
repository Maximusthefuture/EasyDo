//
//  DailyItems+CoreDataProperties.swift
//  EasyDo
//
//  Created by Maximus on 19.01.2022.
//
//

import Foundation
import CoreData


extension DailyItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyItems> {
        return NSFetchRequest<DailyItems>(entityName: "DailyItems")
    }

    @NSManaged public var inTime: Date?
    @NSManaged public var inDate: Date?
    @NSManaged public var task: Task?
    //pomodoroCount?

}

extension DailyItems : Identifiable {

}
