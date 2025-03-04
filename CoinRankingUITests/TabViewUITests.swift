//
//  TabViewUITests.swift
//  CoinRankingUITests
//
//  Created by Mike Kihiu on 03/03/2025.
//

import XCTest

final class TabViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        //
    }

    func testAppHasTwoTabs() throws {
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertNotNil(tabBar.buttons["Favorites"])
        XCTAssertNotNil(tabBar.buttons["Top Coins"])
    }
}
