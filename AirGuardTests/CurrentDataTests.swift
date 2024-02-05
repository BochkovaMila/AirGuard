//
//  CurrentDataTests.swift
//  AirGuardTests
//
//  Created by Mila B on 05.02.2024.
//

import XCTest
@testable import AirGuard

final class CurrentDataTests: XCTestCase {
    let currentDataView = CurrentDataView()

    func testSuccessfulInterpretationFromAQI() {
        let value = 1
        
        let str = currentDataView.getInterpretationFromAQI(value: value)
        
        XCTAssertEqual(str, "😄 Отлично")
    }
    
    func testInvalidValueInterpretationFromAQI() {
        let value = 100
        
        let str = currentDataView.getInterpretationFromAQI(value: value)
        
        XCTAssertEqual(str, "???")
    }

}
