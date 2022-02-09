//
//  EasyDoUITests.swift
//  EasyDoUITests
//
//  Created by Maximus on 21.01.2022.
//

import XCTest

class EasyDoUITests: XCTestCase {

    var app: XCUIApplication!
  
    override func setUpWithError() throws {
      try super.setUpWithError()
      continueAfterFailure = false
      app = XCUIApplication()
      app.launch()
    }
    
    
    func testTagCreation() {
 
        app.buttons["+ Add Card"].tap()
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 3).children(matching: .other).element(boundBy: 0).tap()
        let createCardButton =  app.buttons["+ Create card"]
        XCTAssertTrue(createCardButton.waitForExistence(timeout: 10))
        createCardButton.tap()
        
//        app.buttons["+ Create card"].tap()
        let enterCardTitleTextField = app.textFields["Enter card title"]
        XCTAssertTrue(enterCardTitleTextField.waitForExistence(timeout: 10))
        enterCardTitleTextField.tap()
        enterCardTitleTextField.typeText("Hello test 2")
                app.navigationBars["EasyDo.AddEditCardView"].buttons["Done"].tap()
//        let cellsQuery = app.collectionViews/*@START_MENU_TOKEN@*/.cells/*[[".scrollViews.cells",".cells"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.collectionViews.cells
        let horizontalScrollBar1PageCollectionView = app.collectionViews.scrollViews.children(matching: .cell).element(boundBy: 0).collectionViews.containing(.other, identifier:"Horizontal scroll bar, 1 page").element
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        horizontalScrollBar1PageCollectionView.swipeUp()
        
        let label = tablesQuery.cells.containing(.staticText, identifier:"Label").children(matching: .other).element(boundBy: 1)
       
        let collectionViewsQuery = app.collectionViews
        let cell2 = collectionViewsQuery.children(matching: .cell).element(boundBy: 2)
        cell2.staticTexts["Hello test 2"].tap()
        label.tap()
        let enterTagNameTextField = app.textFields["Enter tag name"]
        enterTagNameTextField.tap()
        enterTagNameTextField.typeText("Tag1")
        let staticText = app/*@START_MENU_TOKEN@*/.staticTexts["+"]/*[[".buttons[\"+\"].staticTexts[\"+\"]",".staticTexts[\"+\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText.tap()
        enterTagNameTextField.tap()
        
        enterTagNameTextField.typeText("Tag2")
        staticText.tap()
                
//        app.windows.firstMatch.tap()
       let backButton =  app/*@START_MENU_TOKEN@*/.buttons["Back"].staticTexts["Back"]/*[[".buttons[\"Back\"].staticTexts[\"Back\"]",".staticTexts[\"Back\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        XCTAssertTrue(backButton.waitForExistence(timeout: 10))
        backButton.tap()
        XCTAssertTrue(label.waitForExistence(timeout: 10))

        XCTAssert(tablesQuery.staticTexts["Tag1"].waitForExistence(timeout: 2.0))
        XCTAssert(tablesQuery.staticTexts["Tag2"].waitForExistence(timeout: 2.0))
    }
    
    func testCreateProject() {
        
    }
    
    func testCardCompleteCreation() {
       
        
    }
    
    func test_swipe_to_tommorow_daily_task() {
//       app.tables.cells.children(matching: .other).element(boundBy: 1).children(matching: .other).element.swipeRight()
        let tablesQuery = app.tables.cells
        let cell = tablesQuery.children(matching: .other).element(boundBy: 1)
        let rightOffset = CGVector(dx: 0.95, dy: 0.5)
        let leftOffset = CGVector(dx: 0.05, dy: 0.5)
        let cellFarLeftCoordinate = cell.coordinate(withNormalizedOffset: leftOffset)
//        tablesQuery.children(matching: .other).element(boundBy: 1).swipeRight(velocity: .fast)
//        tablesQuery.children(matching: .other).element(boundBy: 1).swipeRight(velocity: .fast)
        let cellFarRightCoordinate = cell.coordinate(withNormalizedOffset: rightOffset)
        cellFarLeftCoordinate.press(forDuration: 0.3, thenDragTo: cellFarRightCoordinate)
//        tablesQuery.children(matching: .other).element(boundBy: 1).buttons["Delete"].tap()
        XCTAssertEqual(cell.waitForExistence(timeout: 2), false)
        
                        
                                
        
    }
    
    
    func testNoDeadLineToggle() {
        app.buttons["+ Add Card"].tap()
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 3).children(matching: .other).element(boundBy: 0).tap()
        let createCardButton =  app.buttons["+ Create card"]
        XCTAssertTrue(createCardButton.waitForExistence(timeout: 10))
        createCardButton.tap()
        var circlularCheckbox = app.tables/*@START_MENU_TOKEN@*/.otherElements["CircularCheckbox"]/*[[".cells.otherElements[\"CircularCheckbox\"]",".otherElements[\"CircularCheckbox\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        circlularCheckbox.tap()
        let datePicker = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element
        XCTAssert(!datePicker.isHittable)
    }
    
    func testDragAndDrop() {
        
        
        app.buttons["+ Add Card"].tap()
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element(boundBy: 0).tap()

        let from = app.collectionViews/*@START_MENU_TOKEN@*/.cells/*[[".scrollViews.cells",".cells"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.collectionViews.cells.otherElements.containing(.staticText, identifier:"Qweqwe").children(matching: .other).element(boundBy: 0)
        let to = app.collectionViews/*@START_MENU_TOKEN@*/.cells/*[[".scrollViews.cells",".cells"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.collectionViews.cells.otherElements.containing(.staticText, identifier:"Some task").children(matching: .other).element(boundBy: 0)
        
        from.press(forDuration: 2, thenDragTo: to)
        
//        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element.children(matching: .scrollView).element.swipeLeft()
    
        XCTAssert(from.waitForExistence(timeout: 10))
    
    }

    
    
    
}
