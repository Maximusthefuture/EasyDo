//
//  AddEditCardViewModel.swift
//  EasyDo
//
//  Created by Maximus on 23.01.2022.
//

import Foundation



protocol AddEditCardViewModelProtocol: ViewModelBased {
    func createNewTask()
    func addCardToDayTask(time: Date?, date: Date?)
    var cardName: String? { get set }
    var cardDescription: String? { get set }
    var dueDate: Date? { get set }
    var tagsArray: [String] { get set }
    var taskDetail: Task? { get set }
}

class AddEditCardViewModel: AddEditCardViewModelProtocol {
    
    required init() {
        
    }
    
    var cardName: String? { didSet { } }
    var cardDescription: String? { didSet { } }
    
    var coreDataStack: CoreDataStack?
    var tagsArray = [String]()
    var dueDate: Date?
    var currentProject: Project?
    var taskDetail: Task?
    
    init(coreDataStack: CoreDataStack, currentProject: Project?) {
        self.coreDataStack = coreDataStack
        self.currentProject = currentProject
        
    }
    
    func createNewTask() {
        if let coreDataStack = coreDataStack {
            let task = Task(context: coreDataStack.managedContext)
            task.tags = tagsArray
            task.mainTag = "No tag"
            task.title = cardName
            task.taskDescription = cardDescription
            //MARK: If mydate nil, add date + 2 days?
            task.dueDate = dueDate ?? Date()
            if let project = currentProject,
               let tasks = project.tasks?.mutableCopy() as? NSMutableOrderedSet {
                tasks.add(task)
                project.tasks = tasks
            }
            coreDataStack.saveContext()
        }
    }
    
    func addCardToDayTask(time: Date?, date: Date?) {
        updateTask(time: time, date: date)
    }
    
    func updateTask(time: Date?, date: Date?) {
        if let coreDataStack = self.coreDataStack {
            let dailyItem = DailyItems(context: coreDataStack.managedContext)
            dailyItem.task = self.taskDetail
            dailyItem.inTime = time
            dailyItem.inDate = date?.onlyDate
            self.taskDetail?.mainTag = "In Progress"
            coreDataStack.saveContext()
        } else {
            //            error handling?
            print("NULL NULL NULL")
        }
    } 
}
