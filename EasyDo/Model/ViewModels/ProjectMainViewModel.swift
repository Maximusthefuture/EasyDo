//
//  ProjectMainViewModel.swift
//  EasyDo
//
//  Created by Maximus on 04.02.2022.
//

import Foundation


protocol ProjectMainViewModelProtocol {
    var currentProject: Project? { get set }
    var filteredArrayByTag: [Task]? { get set}
    var coreDataStack: CoreDataStack? { get }
}

class ProjectMainViewModel: ProjectMainViewModelProtocol {
    
    var currentProject: Project?
    var filteredArrayByTag: [Task]?
    
    var coreDataStack: CoreDataStack?
    
    init(coreDataStack: CoreDataStack, currentProject: Project?) {
        self.coreDataStack = coreDataStack
        self.currentProject = currentProject
    }
    
    
}
