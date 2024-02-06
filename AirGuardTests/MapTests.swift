//
//  MapTests.swift
//  AirGuardTests
//
//  Created by Mila B on 06.02.2024.
//

import XCTest
@testable import AirGuard
import SwiftUI

final class MapTests: XCTestCase {
    
    let viewModel = MapViewModel()
    let mapView = MapView(viewModel: MapViewModel(), selectedParam: .index)
    
    
    let point = InfoPoint(name: "Zelenograd", coordinate: MapDetails.startingLocation, aqData: AirQualityData(coord: Coord(lon: 50.0, lat: 50.0), list: [List(dt: 1606147200, main: Main(aqi: 4), components: ["co": 211.954, "so2": 0.648, "no2": 0.217, "o3": 72.956, "pm2_5": 2.563, "pm10": 5.757]), List(dt: 1606147200, main: Main(aqi: 4), components: ["so" : 0.648])]))

    func testLoadAnnotations() {
        viewModel.loadAnnotationsByCurrentLocation()
        
        XCTAssertNotNil(viewModel.searchResults)
    }
    
    func testGetColorForAQI() {
        mapView.selectedParam = .index
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.red)
    }
    
    func testGetColorForSO2() {
        mapView.selectedParam = .SO2
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.green)
    }
    
    func testGetColorForNO2() {
        mapView.selectedParam = .NO2
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.green)
    }
    
    func testGetColorForO3() {
        mapView.selectedParam = .O3
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.yellow)
    }
    
    func testGetColorForCO() {
        mapView.selectedParam = .CO
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.green)
    }
    
    func testGetColorForPM2() {
        mapView.selectedParam = .PM2
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.green)
    }
    
    func testGetColorForPM10() {
        mapView.selectedParam = .PM10
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.green)
    }
    
    func testGetInfoForAQI() {
        let mapView = MapView(viewModel: MapViewModel())
        mapView.selectedParam = .index
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "4")
    }
    
    func testGetInfoForSO2() {
        mapView.selectedParam = .SO2
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "0.6")
    }
    
    func testGetInfoForNO2() {
        mapView.selectedParam = .NO2
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "0.2")
    }
    
    func testGetInfoForPM10() {
        mapView.selectedParam = .PM10
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "5.7")
    }
    
    func testGetInfoForPM2() {
        mapView.selectedParam = .PM2
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "2.5")
    }
    
    func testGetInfoForO3() {
        mapView.selectedParam = .O3
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "72.9")
    }
    
    func testGetInfoForCO() {
        mapView.selectedParam = .CO
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "211.9")
    }
    
}
