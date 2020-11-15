//
//  Heroes_iOSUITests.swift
//  Heroes iOSUITests
//
//  Created by TR64UV on 08/11/2020.
//

import XCTest

class HeroesiOSUITests: XCTestCase {
    var app: XCUIApplication = XCUIApplication()
    override func setUp() {
            super.setUp()

            // Since UI tests are more expensive to run, it's usually a good idea
            // to exit if a failure was encountered
            continueAfterFailure = false

            app = XCUIApplication()

            // We send a command line argument to our app,
            // to enable it to reset its state
            app.launchArguments.append("--uitesting")
        }

    func testHeroesList() throws {
        app.launch()
        XCTAssertTrue(app.isDisplayingHeroesList)
        let firstHeroes = app.staticTexts["Amiko"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: firstHeroes, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    func testHeroesDetail() throws {
        app.launch()
        XCTAssertTrue(app.isDisplayingHeroesList)
        let myTable = app.tables.matching(identifier: "heroesTableView")
        let cell = myTable.cells.element(matching: .cell, identifier: "A-Bomb (HAS)")
        cell.tap()
        XCTAssertTrue(app.isDisplayingHeroesDetail)
        let detailButton = app.buttons["detail"]
        XCTAssertTrue(detailButton.exists)
        detailButton.tap()
        sleep(5)
        app.swipeUp()
        sleep(3)
        app.swipeDown()
        sleep(2)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCUIApplication {
    var isDisplayingHeroesList: Bool {
        return otherElements["HeroesListController"].exists
    }
    var isDisplayingHeroesDetail: Bool {
        return otherElements["HeroeDetailViewController"].exists
    }
}
