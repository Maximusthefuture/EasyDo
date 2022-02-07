//
//  AddEditCardViewModel.swift
//  EasyDo
//
//  Created by Maximus on 23.01.2022.
//

import Foundation



protocol AddEditCardViewModelProtocol: ViewModelBased {
    func addCardToDayTask(time: Date?, date: Date?)
    var cardName: String? { get set }
    var cardDescription: String? { get set }
    var dueDate: Date? { get set }
    var tagsArray: [String] { get set }
    var taskDetail: Task? { get set }
    var recentlyUsedTags: [String]? { get set }
    var bindableIsFormValidObserver: Bindable<Bool> { get set }
    var pomodoroCount: Int? { get set }
    var coreDataStack: CoreDataStack? { get }
    func updateCreateTask() throws
  
}

//Заполненые поля даты сразу?
//Заполнение полей сразу здесь
class AddEditCardViewModel: AddEditCardViewModelProtocol {
    
    var bindableIsFormValidObserver: Bindable<Bool> = Bindable(false)
   
    //Change this to db after?
    var recentlyUsedTags: [String]?
    
    required init() { }
    
    var cardName: String? { didSet { checkFormValidation() } }
    var cardDescription: String? { didSet { checkFormValidation() }}
    var pomodoroCount: Int?
    var coreDataStack: CoreDataStack?
    var tagsArray = [String]()
    var dueDate: Date?
    var currentProject: Project?
    var taskDetail: Task?
    var state: AddEditTaskState?
    
    init(coreDataStack: CoreDataStack, currentProject: Project?, task: Task?, state: AddEditTaskState) {
        self.coreDataStack = coreDataStack
        self.currentProject = currentProject
        self.taskDetail = task
        self.cardName = task?.title
        self.pomodoroCount = Int(task?.pomodoroCount ?? 0)
        self.cardDescription = task?.taskDescription
        self.state = state
    }
    
    convenience init(coreDataStack: CoreDataStack, task: Task?, state: AddEditTaskState) {
        self.init(coreDataStack: coreDataStack, currentProject: task?.project, task: task, state: state)
        self.taskDetail = task
        self.state = state
    }
    
    func addRecenltyUsedTags(tag: String) {
        recentlyUsedTags?.append(tag)
    }
    
    fileprivate func checkFormValidation() {
        let isFormValid = cardName?.isEmpty == false && cardName!.count <= 20 &&
            cardDescription?.isEmpty == false && cardDescription!.count <= 45
        bindableIsFormValidObserver.value = isFormValid
//        if cardName!.count < 18 || cardDescription!.count < 40  {
////            bindableError.value = Errors.CardNameValidationError.tooLong
//            print("TOOO LONG")
//        }
    }
    
    func updateCreateTask() throws {
        switch state {
        case .edit:
            updateTask()
        case .new:
            try? createNewTask()
        case .none:
            throw Errors.CardNameValidationError.tooLong
        }
    }
    
//    repository.saveTask(name: _, tag: _, taskDescription: _, pomodoroCount: _, )
    fileprivate func createNewTask() throws {
        if let coreDataStack = coreDataStack {
            let task = Task(context: coreDataStack.managedContext)
            task.tags = tagsArray
            task.mainTag = "No tag"
            task.title = cardName
            task.taskDescription = cardDescription
            task.pomodoroCount = Int16(pomodoroCount ?? 0)
            //MARK: If mydate nil, add date + 2 days?
            task.dueDate = dueDate ?? Date(timeIntervalSince1970: 0)
            if let project = currentProject,
               let tasks = project.tasks?.mutableCopy() as? NSMutableOrderedSet {
                tasks.add(task)
                project.tasks = tasks
            }
            coreDataStack.saveContext()
        }
    }
    
    func addCardToDayTask(time: Date?, date: Date?) {
        saveToDayTask(time: time, date: date)
    }
    
//    repository.updateTask()
   fileprivate func updateTask() {
        taskDetail?.title = cardName
        taskDetail?.taskDescription = cardDescription
        taskDetail?.pomodoroCount = Int16(pomodoroCount ?? 0 )
        taskDetail?.tags = tagsArray
        coreDataStack?.saveContext()
        
    }
    
    fileprivate func saveToDayTask(time: Date?, date: Date?) {
        if let coreDataStack = coreDataStack {
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
