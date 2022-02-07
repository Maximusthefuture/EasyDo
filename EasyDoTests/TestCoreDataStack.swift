//
//  TestCoreDataStack.swift
//  EasyDoTests
//
//  Created by Maximus on 07.02.2022.
//

import Foundation
@testable import EasyDo
import CoreData

class TestCoreDataStack: CoreDataStack {
   
      let model: NSManagedObjectModel = {
      // swiftlint:disable force_unwrapping
      let modelURL = Bundle.main.url(forResource: "EasyDo", withExtension: "momd")!
      return NSManagedObjectModel(contentsOf: modelURL)!
      // swiftlint:enable force_unwrapping
    }()
    override init(modelName: String) {
        super.init(modelName: modelName)
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("FKLDSLFKDS")
            }
        }
        self.storeContainer = container
    }
}
