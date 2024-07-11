//
//  PerformanceTests.swift
//  AirGuardTests
//
//  Created by Mila B on 03.04.2024.
//

import XCTest
@testable import AirGuard

final class PerformanceTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testPerformanceOfSearchLocation() throws {
        self.measure(metrics: [XCTMemoryMetric(), XCTStorageMetric()]) {
            let vm = LocationSearchViewModel()
            vm.searchAddress("London Eye")
        }
    }
