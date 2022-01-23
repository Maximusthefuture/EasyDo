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
////        label.tap()
//        XCTAssertEqual(label.staticTexts.element.label, "Tag1")
//        XCUIApplication().tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"13:10").element/*[[".cells.containing(.staticText, identifier:\"UIMenu\").element",".cells.containing(.staticText, identifier:\"13:10\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        XCTAssert(label.children(matching: .other)["Tag1"].waitForExistence(timeout: 1.0))
    
//        XCTAssertEqual(app.otherElements.staticTexts["Tag1"], "Tag1")
        
        //TAGVIEW
//        app.label.descendants(matching: .other)["Tag1"].tap()
        
//        tablesQuery.staticTexts["Tag1"].tap()
      
        XCTAssert(tablesQuery.staticTexts["Tag1"].waitForExistence(timeout: 2.0))
        XCTAssert(tablesQuery.staticTexts["Tag2"].waitForExistence(timeout: 2.0))
//        XCTAssertEqual(tablesQuery.staticTexts, "Tag2")
        //
    }
    
    func testCreateProject() {
        
    }

  func testGameStyleSwitch() {
      
      // given
      //    let slideButton = app.segmentedControls.buttons["Slide"]
      //    let typeButton = app.segmentedControls.buttons["Type"]
      //    let slideLabel = app.staticTexts["Get as close as you can to: "]
      //    let typeLabel = app.staticTexts["Guess where the slider is: "]
      //
      //    // then
      //    if slideButton.isSelected {
      //      XCTAssertTrue(slideLabel.exists)
      //      XCTAssertFalse(typeLabel.exists)
      //
      //      typeButton.tap()
      //      XCTAssertTrue(typeLabel.exists)
      //      XCTAssertFalse(slideLabel.exists)
      //    } else if typeButton.isSelected {
      //      XCTAssertTrue(typeLabel.exists)
      //      XCTAssertFalse(slideLabel.exists)
      //
      //      slideButton.tap()
      //      XCTAssertTrue(slideLabel.exists)
      //      XCTAssertFalse(typeLabel.exists)
      //    }
      
  }
    
    
    
}
