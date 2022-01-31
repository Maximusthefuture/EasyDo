//
//  ViewControllerFactory.swift
//  EasyDo
//
//  Created by Maximus on 31.01.2022.
//

import Foundation

protocol ViewControllerFactory {
    func makeDayTasksViewContoller() -> DayTasksViewController
    func addEditTaskViewController(task: Task) -> AddEditTaskViewController
}

protocol ViewModelFactory {
    func makeAddEditViewModel(coreDataStack: CoreDataStack, currentProject: Project?) -> AddEditCardViewModelProtocol
    func makeDayTaskViewModel() -> DayTaskViewModelProtocol
}
