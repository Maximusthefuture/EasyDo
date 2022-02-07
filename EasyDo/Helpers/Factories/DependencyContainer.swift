//
//  DependencyContainer.swift
//  EasyDo
//
//  Created by Maximus on 31.01.2022.
//

import Foundation


class DependencyContainer {
    
   static let coreDataStack = CoreDataStack(modelName: "EasyDo")

}

extension DependencyContainer: ViewControllerFactory {
    func makeProjectMainViewController(currentProject: Project?) -> ProjectMainViewController {
        return ProjectMainViewController(viewModel: makeProjectMainViewModel(currentProject: currentProject))
    }
    
    func makeProjectListViewController() -> ProjectsListViewController {
        return ProjectsListViewController(viewModel: makeProjectListViewModel())
    }
    
    func makeDayTasksViewContoller() -> DayTasksViewController {
        return DayTasksViewController(viewModel: makeDayTaskViewModel())
    }
    
    func addEditTaskViewController(task: Task?, state: AddEditTaskState, currentProject: Project?) -> AddEditTaskViewController {
        return AddEditTaskViewController(viewModel: makeAddEditViewModel(currentProject: currentProject, task: task, state: state))
    }
}

extension DependencyContainer: ViewModelFactory {
    func makeProjectMainViewModel(currentProject: Project?) -> ProjectMainViewModelProtocol {
        return ProjectMainViewModel(coreDataStack: DependencyContainer.coreDataStack, currentProject: currentProject)
    }
    
    func makeProjectListViewModel() -> ProjectListViewModelProtocol {
        return ProjectListViewModel(coreDataStack: DependencyContainer.coreDataStack)
    }
    
    func makeAddEditViewModel(currentProject: Project?, task: Task?, state: AddEditTaskState) -> AddEditCardViewModelProtocol {
        return AddEditCardViewModel(coreDataStack: DependencyContainer.coreDataStack, currentProject: currentProject, task: task, state: state)
    }
    
    func makeDayTaskViewModel() -> DayTaskViewModelProtocol {
        return DayTasksViewModel(coreDataStack: DependencyContainer.coreDataStack)
    }
    
    
}
