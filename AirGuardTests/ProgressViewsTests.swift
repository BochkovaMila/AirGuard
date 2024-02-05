//
//  ProgressViewsTests.swift
//  AirGuardTests
//
//  Created by Mila B on 05.02.2024.
//

import XCTest
import SwiftUI
@testable import AirGuard

final class ProgressViewsTests: XCTestCase {

    func testSuccessfulGetColorAndProgress() {
        let value = 2
        let aqiProgressView = CrescentProgressView(value: value)
        
        let (color, progress) = aqiProgressView.getColorAndProgress()
        
        XCTAssertEqual(color, Color.yellow)
        XCTAssertEqual(progress, 0.2)
    }
    
    func testInvalidValueGetColorAndProgress() {
        let value = -2
        let aqiProgressView = CrescentProgressView(value: value)
        
        let (color, progress) = aqiProgressView.getColorAndProgress()
        
        XCTAssertEqual(color, Color.gray)
        XCTAssertEqual(progress, 0.0)
    }
    
    func testSuccessfulGetColorAndProgressForSO2() {
        let param = "SO2"
        let value = 0.0
        let vertProgressView = VerticalProgressView(param: param, value: value)
        
        let (color, progress) = vertProgressView.getColorAndProgressForSelectedParam()
        
        XCTAssertEqual(color, Color.green)
        XCTAssertEqual(progress, 0.1)
    }
    
    func testSuccessfulGetColorAndProgressForNO2() {
        let param = "NO2"
        let value = 50.0
        let vertProgressView = VerticalProgressView(param: param, value: value)
        
        let (color, progress) = vertProgressView.getColorAndProgressForSelectedParam()
        
        XCTAssertEqual(color, Color.yellow)
        XCTAssertEqual(progress, 0.25)
    }
    
    func testSuccessfulGetColorAndProgressForPM10() {
        let param = "PM10"
        let value = 50.0
        let vertProgressView = VerticalProgressView(param: param, value: value)
        
        let (color, progress) = vertProgressView.getColorAndProgressForSelectedParam()
        
        XCTAssertEqual(color, Color.orange)
        XCTAssertEqual(progress, 0.25)
    }
    
    func testSuccessfulGetColorAndProgressForPM2() {
        let param = "PM2.5"
        let value = 50.0
        let vertProgressView = VerticalProgressView(param: param, value: value)
        
        let (color, progress) = vertProgressView.getColorAndProgressForSelectedParam()
        
        XCTAssertEqual(color, Color.red)
        XCTAssertEqual(progress, 2/3)
    }
    
    func testSuccessfulGetColorAndProgressForO3() {
        let param = "O3"
        let value = 185.0
        let vertProgressView = VerticalProgressView(param: param, value: value)
        
        let (color, progress) = vertProgressView.getColorAndProgressForSelectedParam()
        
        XCTAssertEqual(color, Color("darkRed"))
        XCTAssertEqual(progress, 0.95)
    }
    
    func testSuccessfulGetColorAndProgressForCO() {
        let param = "CO"
        let value = 15400.0
        let vertProgressView = VerticalProgressView(param: param, value: value)
        
        let (color, progress) = vertProgressView.getColorAndProgressForSelectedParam()
        
        XCTAssertEqual(color, Color("darkRed"))
        XCTAssertEqual(progress, 0.95)
    }
    
    func testInvalidParamGetColorAndProgress() {
        let param = "-1"
        let value = 185.0
        let vertProgressView = VerticalProgressView(param: param, value: value)
        
        let (color, progress) = vertProgressView.getColorAndProgressForSelectedParam()
        
        XCTAssertEqual(color, Color.gray)
        XCTAssertEqual(progress, 0.0)
    }
    
    func testInvalidValueGetColorAndProgressForSO2() {
        let param = "SO2"
        let value = -20.0
        let vertProgressView = VerticalProgressView(param: param, value: value)
        
        let (color, progress) = vertProgressView.getColorAndProgressForSelectedParam()
        
        XCTAssertEqual(color, Color.gray)
        XCTAssertEqual(progress, 0.0)
    }

}
