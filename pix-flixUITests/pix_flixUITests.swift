//
//  pix_flixUITests.swift
//  pix-flixUITests
//
//  Created by Daniel Almeida on 28/08/2024.
//

import XCTest
import SwiftData


final class pix_flixUITests: XCTestCase {

    
    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        /*
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Project.self, configurations: config)

        do {
            container.deleteAllData()
            try container.mainContext.delete(model: Project.self)
           
        } catch {
            print("Failed to clear all data.")
        }
         */
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        XCTAssert(app.windows.count == 1)
        XCTAssert(app.buttons["Encode"].isHittable)
        XCTAssert(app.buttons["Configuration"].isHittable)
    }
    
    
    func testClickingPlusSignShowsNewProjectWindow() throws {
        let app = XCUIApplication()
        app.launchArguments =  ["enable-testing"]
        app.launch()
        
        let plusButton = app.windows.toolbars.children(matching: .button)["New Project"]
        
        XCTAssertTrue(plusButton.exists)
        
        plusButton.click()
        
        XCTAssert(app.windows.firstMatch.sheets.count == 1)
        XCTAssert(app.windows.firstMatch.sheets.textFields.count == 1)
        XCTAssert(app.windows.firstMatch.sheets.firstMatch.buttons.count == 2)
        XCTAssertTrue(app.windows.firstMatch.sheets.firstMatch.buttons["Create new Project"].exists)
        XCTAssertTrue(app.windows.firstMatch.sheets.firstMatch.buttons["Cancel"].exists)
        
        let textField = app.windows.firstMatch.sheets.textFields["New name"]
        textField.click()
        textField.typeText("New Project 001")
        app.windows.firstMatch.sheets.firstMatch.buttons["Create new Project"].click()
        XCTAssert(app.windows.firstMatch.sheets.count == 0)
        
        let projectsList = app.outlines["Sidebar"]
        XCTAssertTrue(projectsList.cells.containing(.button, identifier: "New Project 001").element.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
}
