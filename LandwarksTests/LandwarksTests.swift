//
//  LandwarksTests.swift
//  LandwarksTests
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import XCTest
import SwiftUI
@testable import Trickl

class LandwarksTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testAngleConstructor() throws {
        
        
        /// edge cases
        XCTAssertEqual(Angle(x: 0, y: -1), Angle(degrees: -90))
        XCTAssertEqual(Angle(x: 0, y: +1), Angle(degrees: 90))
        XCTAssertEqual(Angle(x: +1, y: 0), Angle(degrees: 0))
        XCTAssertEqual(Angle(x: -1, y: 0), Angle(degrees: 180))
        
        /// simple angles
        XCTAssertEqual(Angle(x: 1, y: 1), Angle(degrees: 45))
        XCTAssertEqual(Angle(x: 1, y: -1), Angle(degrees: -45))
        XCTAssertEqual(Angle(x: -1, y: 1), Angle(degrees: 135))
        XCTAssertEqual(Angle(x: -1, y: -1), Angle(degrees: 225))
    }
    
    func testMeanTime() throws {
        let cal = Calendar.current
        let midnight = cal.startOfDay(for: Date())
        
        // average of 2 equals
        XCTAssertEqual([midnight, midnight].meanTime(), midnight)
        
        // average of across midnight
        XCTAssertEqual([
            midnight.addingTimeInterval(-3600),
            midnight.addingTimeInterval(+3600)
        ].meanTime(), midnight)
    }
    
    func testTime24h() throws {
        
        let cal = Calendar.current
        let midnight = cal.startOfDay(for: Date())
        
        XCTAssertEqual(
            Angle(degrees: 0).time24h(),
            midnight
        )
        
        XCTAssertEqual(
            Angle(degrees: 90).time24h(),
            midnight.addingTimeInterval(3600 * 6)
        )
        
        XCTAssertEqual(
            Angle(degrees: 360).time24h(),
            midnight.addingTimeInterval(dayLength)
        )
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
