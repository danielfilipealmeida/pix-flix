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
        let bundle = Bundle(for: type(of: self))
         
        let urls = [
            URL(fileURLWithPath: bundle.path(forResource: "testimage1", ofType: "png")!),
            URL(fileURLWithPath: bundle.path(forResource: "testimage2", ofType: "png")!)
        ]
        let result = getNSImageArrayFromURLArray(urls)
        
        XCTAssert(result.count == 2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
