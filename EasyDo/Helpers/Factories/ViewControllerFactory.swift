//
//  ViewControllerFactory.swift
//  EasyDo
//
//  Created by Maximus on 31.01.2022.
//

import Foundation

protocol ViewControllerFactory {
    func makeDayTasksViewContoller() -> DayTasksViewController
    func addEditTaskViewController(task: Task, state: AddEditTaskState, currentProject: Project?) -> AddEditTaskViewController
}

protocol ViewModelFactory {
    func makeAddEditViewModel(currentProject: Project?, task: Task?) -> AddEditCardViewModelProtocol
    func makeDayTaskViewModel() -> DayTaskViewModelProtocol
}
