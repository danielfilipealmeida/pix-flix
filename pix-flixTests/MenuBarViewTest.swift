//
//  MenuBarViewTest.swift
//  pix-flixTests
//
//  Created by Daniel Almeida on 01/09/2024.
//

import XCTest

final class MenuBarViewTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getNSImageArrayFromURLArray() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let urls = [
            URL(fileURLWithPath: "/file1"),
            URL(fileURLWithPath: "/file2"),
        ]
        let result = getNSImageArrayFromURLArray(urls)
        
        //XCTAssert(1 == 2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
