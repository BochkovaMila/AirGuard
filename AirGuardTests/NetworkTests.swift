//
//  NetworkTests.swift
//  AirGuardTests
//
//  Created by Mila B on 06.02.2024.
//

import XCTest
@testable import AirGuard

final class NetworkTests: XCTestCase {

    func testCurrentDataFetching() async throws {
        let data = try await NetworkManager.shared.getCurrentData(latitude: MapDetails.startingLocation.latitude, longitude: MapDetails.startingLocation.longitude)
        
        XCTAssertNotNil(data)
    }
    
    func testForecastDataFetching() async throws {
        let data = try await NetworkManager.shared.getForecastData(latitude: MapDetails.startingLocation.latitude, longitude: MapDetails.startingLocation.longitude)
        
        XCTAssertNotNil(data)
    }
    
    func testHistoricalDataFetching() async throws {
        let data = try await NetworkManager.shared.getHistoricalData(lat: MapDetails.startingLocation.latitude, lon: MapDetails.startingLocation.longitude, start: 1606223802, end: 1606482999)
        
        XCTAssertNotNil(data)
    }

}
