//
//  DayTasksViewModel.swift
//  EasyDo
//
//  Created by Maximus on 24.01.2022.
//

import Foundation

protocol DayTaskViewModelProtocol: AnyObject {
    func isCurrentDate(date: Date) -> Bool
    func setPredicateByDate(date: Date) -> NSPredicate
    var currentWeek: [Date] { get set }   
}

class DayTasksViewModel: ViewModelBased, DayTaskViewModelProtocol {
    
    var coreDataStack: CoreDataStack?
    
    required init() {
    }
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        fetchCurrentWeek()
       
    }
 
    func isCurrentDate(date: Date) -> Bool {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let currentDay = calendar.component(.day, from: Date())
        return day == currentDay
    }
    
    func setPredicateByDate(date: Date) -> NSPredicate{
        return NSPredicate(format: "%K == %@", #keyPath(DailyItems.inDate), date as NSDate)
    }
    
    var currentWeek: [Date] = []
    
    //MARK: MOVE TO VIEWMODEL
    //Add to coredata????
    private func fetchCurrentWeek() {
        let today = Date()
        var calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        calendar.timeZone = .autoupdatingCurrent
        guard let firstWeekDay = week?.start else { return }
        
        (0...30).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
               
                currentWeek.append(weekday)
              
            }
        }
    }
   
}
