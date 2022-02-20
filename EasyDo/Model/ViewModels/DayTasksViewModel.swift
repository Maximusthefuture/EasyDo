//
//  DayTasksViewModel.swift
//  EasyDo
//
//  Created by Maximus on 24.01.2022.
//

import Foundation
import CoreData

protocol DayTaskViewModelProtocol: AnyObject {
    func isCurrentDate(date: Date) -> Bool
    func setPredicateByDate(date: Date) -> NSPredicate
    var currentWeek: [Date] { get set }
    var coreDataStack: CoreDataStack? { get }
    func moveToNextDay(indexPath: Int, fetchRequest: NSFetchRequest<DailyItems>)
    func deleteItem(indexPath: Int, fetchRequest: NSFetchRequest<DailyItems>)
    func getPomodoroCount(pomodoroCount: Int) -> Int
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
    
    
    func moveToNextDay(indexPath: Int, fetchRequest: NSFetchRequest<DailyItems>) {
        let item = try? coreDataStack?.managedContext.fetch(fetchRequest)
        let taskDate = item?[indexPath].inDate
        let nextDay = getItemDate(itemDate: taskDate)
        item?[indexPath].inDate = nextDay.onlyDate
        coreDataStack?.saveContext()
    }
    
    func deleteItem(indexPath: Int, fetchRequest: NSFetchRequest<DailyItems>) {
        let item = try? coreDataStack?.managedContext.fetch(fetchRequest)
        item?[indexPath].task?.mainTag = "Done"
        coreDataStack?.managedContext.delete(item![indexPath])
        coreDataStack?.saveContext()
    }
    
    fileprivate func getItemDate(itemDate: Date?) -> Date {
        let calendar = Calendar.current
        var futureComponents = DateComponents()
        futureComponents.day = 1
        guard let itemDate = itemDate else { return Date() }
        let nextDay = calendar.date(byAdding: futureComponents, to: itemDate)
        return nextDay ?? Date()
    }
    
    func setPredicateByDate(date: Date) -> NSPredicate {
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
        
        (0...15).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
               
                currentWeek.append(weekday)
              
            }
        }
    }
    
    
    func getPomodoroCount(pomodoroCount: Int) -> Int {
      
        let fetchRequest = NSFetchRequest<DailyItems>(entityName: "DailyItems")
        
//        fetchRequest.resultType = .dictionaryResultType
        
        let sumExpressionDesc = NSExpressionDescription()
        sumExpressionDesc.name = "sumPomodoro"
        //получить помидоры от всех тасков?
        //потом сравнить даты? долго же? хэшмэп быстрое чтение?
        
        let pomodoroCountExp = NSExpression(forKeyPath: #keyPath(DailyItems.task.pomodoroCount))
//        sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [pomodoroCountExp])
//        sumExpressionDesc.expressionResultType = .integer32AttributeType
//        
//        fetchRequest.propertiesToFetch = [sumExpressionDesc]
        
        do {
//            let results = try coreDataStack?.managedContext.fetch(fetchRequest)
//            let resultDict = results?.first
            let oneMoreResult = try coreDataStack?.managedContext.fetch(fetchRequest)
            oneMoreResult?.map({ value in
                print("count", value.task?.pomodoroCount)
            })
//            let count = resultDict?["sumPomodoro"] as? Int ?? 0
            return 0
            
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return 0
    }
    

   
}


extension Date {
    func getTommorowDate() -> Self {
        let calendar = Calendar.current
        var futureComponents = DateComponents()
        futureComponents.day = 1
    
        let nextDay = calendar.date(byAdding: futureComponents, to: self)
        return nextDay ?? Date().getTommorowDate().onlyDate
    }
    
    var tommorow: Date  {
        let calendar = Calendar.current
        var futureComponents = DateComponents()
        futureComponents.day = 1
    
        let nextDay = calendar.date(byAdding: futureComponents, to: self)
        return nextDay ?? Date().getTommorowDate().onlyDate
    }
}
