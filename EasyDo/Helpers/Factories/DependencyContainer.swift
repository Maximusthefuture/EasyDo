//
//  DependencyContainer.swift
//  EasyDo
//
//  Created by Maximus on 31.01.2022.
//

import Foundation


class DependencyContainer {
    
    private lazy var coreDataStack = CoreDataStack(modelName: "EasyDo")
    //MARK: HOW WE CAN DO IT
    private lazy var addEditTaskViewModel = AddEditCardViewModel(coreDataStack: coreDataStack, currentProject: nil)
    
}

extension DependencyContainer: ViewControllerFactory {
    func makeDayTasksViewContoller() -> DayTasksViewController {
        return DayTasksViewController(viewModel: makeDayTaskViewModel())
    }
    
    func addEditTaskViewController(task: Task) -> AddEditTaskViewController {
        return AddEditTaskViewController(viewModel: addEditTaskViewModel, task: task)
    }
}

extension DependencyContainer: ViewModelFactory {
    func makeAddEditViewModel(coreDataStack: CoreDataStack, currentProject: Project?) -> AddEditCardViewModelProtocol {
        return AddEditCardViewModel(coreDataStack: coreDataStack, currentProject: currentProject)
    }
    
    func makeDayTaskViewModel() -> DayTaskViewModelProtocol {
        return DayTasksViewModel(coreDataStack: coreDataStack)
    }
    
    
}
