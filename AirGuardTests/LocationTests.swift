//
//  LocationTests.swift
//  AirGuardTests
//
//  Created by Mila B on 06.02.2024.
//

import XCTest
@testable import AirGuard

final class LocationTests: XCTestCase {
    
    func testGetCoordinate() {
        LocationManager().getCoordinate(from: "Москва, Зеленоград") { coord in
            XCTAssertNotNil(coord)
            XCTAssertTrue(coord!.0 > 55, "Latitude of Zelenograd is 55.9872")
            XCTAssertTrue(coord!.0 < 56, "Latitude of Zelenograd is 55.9872")
            XCTAssertTrue(coord!.1 > 37, "Longitude of Zelenograd is 37.2022")
            XCTAssertTrue(coord!.1 < 38, "Longitude of Zelenograd is 37.2022")
        }
    }

    func testLookUpLocation() {
        LocationManager().lookUpLocation(lat: 55.9872, long: 37.2022) { str in
            XCTAssertNotNil(str)
            XCTAssertTrue(str!.contains("Zelenograd"))
        }
    }

}
