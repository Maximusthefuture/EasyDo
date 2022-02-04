//
//  DependencyContainer.swift
//  EasyDo
//
//  Created by Maximus on 31.01.2022.
//

import Foundation


class DependencyContainer {
    
    private lazy var coreDataStack = CoreDataStack(modelName: "EasyDo")
}

extension DependencyContainer: ViewControllerFactory {
    func makeDayTasksViewContoller() -> DayTasksViewController {
        return DayTasksViewController(viewModel: makeDayTaskViewModel())
    }
    
    func addEditTaskViewController(task: Task, state: AddEditTaskState, currentProject: Project?) -> AddEditTaskViewController {
        return AddEditTaskViewController(viewModel: makeAddEditViewModel(currentProject: currentProject, task: task), task: task, state: state)
    }
}

extension DependencyContainer: ViewModelFactory {
    func makeAddEditViewModel(currentProject: Project?, task: Task?) -> AddEditCardViewModelProtocol {
        return AddEditCardViewModel(coreDataStack: coreDataStack, currentProject: currentProject, task: task)
    }
    
    func makeDayTaskViewModel() -> DayTaskViewModelProtocol {
        return DayTasksViewModel(coreDataStack: coreDataStack)
    }
    
    
}
