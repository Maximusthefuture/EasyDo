//
//  AddEditCardViewModel.swift
//  EasyDo
//
//  Created by Maximus on 23.01.2022.
//

import Foundation



protocol AddEditCardViewModelProtocol: ViewModelBased {
    func createNewTask()
    var cardName: String? { get set }
    var cardDescription: String? { get set }
    var dueDate: Date? { get set }
    var tagsArray: [String] { get set }
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
    
    
    
    
//    func addCardToDayTask() {
////        let vc = PickTimeViewController(initialHeight: 300)
////        present(vc, animated: true)
//
////        vc.changeDate = { [weak self] date in
////            self?.date = date
//////                  viewModel.date = date
////        }
////        vc.changeTime = { [weak self] time in
////            self?.time = time
////        viewModel.time = time
////
////        }
//
//        vc.dataIsSaved = { [weak self] in
//
////            self?.presentingViewController?.dismiss(animated: true)
//        }
//    }
//
//    func updateTask() {
//        if let coreDataStack = self.coreDataStack {
//            let dailyItem = DailyItems(context: coreDataStack.managedContext)
//            dailyItem.task = self.taskDetail
//            guard let date = self.date, let time = self?.time else {
//                return
//            }
//            dailyItem.inTime = time
//             dailyItem.inDate = date.onlyDate
//
//            self.taskDetail?.mainTag = "In Progress"
//            coreDataStack.saveContext()
//        } else {
//            print("NULL NULL NULL")
//        }
//    }
    
    
}
