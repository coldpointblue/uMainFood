//  ----------------------------------------------------
//
//  uMainFoodUITestsLaunchTests.swift
//  Version 1.0
//
//  Unique ID:  DA7F475C-424F-41A9-9CF8-2F6A35C66663
//
//  part of the uMainFoodUITests™ product.
//
//  Written in Swift 5.0 on macOS 14.3
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2024-02-15.
//  
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  (whole app does? … for users)   */
//  ----------------------------------------------------


import XCTest

final class uMainFoodUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
