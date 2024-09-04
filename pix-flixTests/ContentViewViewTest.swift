//
//  ContentViewViewTest.swift
//  pix-flixTests
//
//  Created by Daniel Almeida on 02/09/2024.
//

import XCTest

final class ContentViewViewTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getSizeFromResolutionString() throws {
        XCTAssert(getSizeFromResolutionString("100x200") == CGSize(width: 100, height: 200))
        XCTAssert(getSizeFromResolutionString("100x") == CGSize(width: 100, height: 0))
        XCTAssert(getSizeFromResolutionString("x100") == CGSize(width: 0, height: 100))
        XCTAssert(getSizeFromResolutionString("100") == CGSize(width: 0, height: 0))
        XCTAssert(getSizeFromResolutionString("") == CGSize(width: 0, height: 0))
        XCTAssert(getSizeFromResolutionString("100X200") == CGSize(width: 0, height: 0))
        XCTAssert(getSizeFromResolutionString("Some string") == CGSize(width: 0, height: 0))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
