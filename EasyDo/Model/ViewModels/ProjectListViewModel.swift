//
//  ProjectListViewModel.swift
//  EasyDo
//
//  Created by Maximus on 04.02.2022.
//

import Foundation
import CoreData

protocol ProjectListViewModelProtocol {
    var projects: [Project] { get set }
    func fetchAndReload()
    var coreDataStack: CoreDataStack?{ get }
}

class ProjectListViewModel: ProjectListViewModelProtocol {
    var projects: [Project] = []
    
    var coreDataStack: CoreDataStack?
    private var fetchRequest: NSFetchRequest<Project>?
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        fetchRequest = Project.fetchRequest()
    }
    
    
    
    func fetchAndReload() {
        guard let fetchRequest = fetchRequest else { return }
        do {
            if let coreDataStack = coreDataStack {
                projects = try coreDataStack.managedContext.fetch(fetchRequest)
                //              tableView.reloadData()
            }
            
        } catch let err as NSError {
            print("err while fetching: ", err)
        }
    }
}
