/*  Goal explanation:  Tests run & verify UI not broken + launch time   */


import XCTest

final class uMainFoodUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // Required initial state, such as interface orientation
    }
    
    override func tearDownWithError() throws {
    }
    
    func testExample() throws {
        // UI tests must launch application they test
        // let app = XCUIApplication()
        // app.launch()
        //
        // XCTAssert and related functions verify correct results
    }
    
    func testLaunchPerformance() throws {
        // if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
        //     measure(metrics: [XCTApplicationLaunchMetric()]) {
        //         XCUIApplication().launch()
        //     }
        // }
    }
}
