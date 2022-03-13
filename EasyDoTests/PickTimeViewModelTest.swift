//
//  PickTimeViewModelTest.swift
//  EasyDoTests
//
//  Created by Maximus on 22.02.2022.
//

import XCTest
@testable import EasyDo

class PickTimeViewModelTest: XCTestCase {
    var sut: PickTimeViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PickTimeViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPickTimeViewModel_dateChange() {
        var date = Date()
        date = sut.setPickerTime(date: date, datePicker: .tommorow)
//        var expectedDate = Date().tommorow
        var dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-mm-dd"
        var testingDate = dateFormat.string(from: date)
        let expectedDate = dateFormat.string(from: Date().tommorow)
        XCTAssertEqual(testingDate, expectedDate)
    }
    
    
    
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
