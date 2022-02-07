//
//  AddEditViewModelTest.swift
//  EasyDoTests
//
//  Created by Maximus on 07.02.2022.
//

import XCTest
@testable import EasyDo
import CoreData

var viewModel: AddEditCardViewModel!
var coreDataStack: CoreDataStack!
var task: Task!

class AddEditViewModelTest: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack(modelName: "EasyDo")
    }
    
    func test_task_core_data_creation() {
        var task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: coreDataStack.managedContext) as! Task
        task.title = "Card"
        task.taskDescription = "Card description"
        task.pomodoroCount = 6
        XCTAssertTrue(task.title == "Card")
        XCTAssertEqual(task.taskDescription, "Card description")
        XCTAssertEqual(task.pomodoroCount, 6)

    }
    
    func test_creating_task() {
//        var task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: coreDataStack.managedContext) as! Task
        viewModel = AddEditCardViewModel(coreDataStack: coreDataStack, task: nil, state: .new)
        viewModel.cardName = "Card"
        viewModel.cardDescription = "Description"
        viewModel.pomodoroCount = 5
        try? viewModel.updateCreateTask()
        var fetchRequest = Task.fetchRequest()
        var task = try? coreDataStack.managedContext.fetch(fetchRequest)
        XCTAssertEqual(task?[0].title, "Card")
        XCTAssertEqual(task?[0].taskDescription, "Description")
        XCTAssertEqual(task?[0].pomodoroCount, 5)
    }
    
    func test_editing_task_in_vm() {
                var task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: coreDataStack.managedContext) as! Task
        viewModel = AddEditCardViewModel(coreDataStack: coreDataStack, task: task, state: .edit)
        viewModel.pomodoroCount = 5
        viewModel.cardName = "Card"
        viewModel.cardDescription = "Description"
        try? viewModel.updateCreateTask()
        XCTAssertEqual(task.title, "Card")
        XCTAssertEqual(task.taskDescription, "Description")
        XCTAssertEqual(task.pomodoroCount, 5)
    }
    
    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
       try super.setUpWithError()
//
    }
    
    override class func tearDown() {
        coreDataStack = nil
        super.tearDown()
       
    }

    override func tearDownWithError() throws {
        viewModel = nil
        
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
