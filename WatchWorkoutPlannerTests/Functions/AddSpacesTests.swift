//
//  AddSpacesTests.swift
//  WatchWorkoutPlannerTests
//

import XCTest
@testable import WatchWorkoutPlanner_Extension

class AddSpacesTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testAddSpaces() throws {
        let text = addSpaces(text: "ThisIsATestSentence.")
        
        XCTAssertTrue(text == "This Is A Test Sentence.")
    }
    
    func testAddSpacesEmpty() throws {
        let text = addSpaces(text: "")
        
        XCTAssertTrue(text == "")
    }
    
    func testAddSpacesAllCapital() throws {
        let text = addSpaces(text: "THISISATESTSENTENCE.")

        XCTAssertTrue(text == "T H I S I S A T E S T S E N T E N C E.")
    }
}
