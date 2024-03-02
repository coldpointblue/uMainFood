/*  Goal explanation:  Tests run to ensure stability before release   */


import XCTest
@testable import uMainFood

final class uMainFoodTests: XCTestCase {
    
    func testNonZeroDisplacementDivisor() {
        XCTAssertNotEqual(DCConst.nonZeroDisplacementDivisor, 0, "nonZeroDisplacementDivisor must not = zero")
    }
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    // func testPerformanceExample() throws {
    // self.measure { }
    // }
    
}
