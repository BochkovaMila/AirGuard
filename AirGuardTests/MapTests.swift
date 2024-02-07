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
    
    let point = InfoPoint(name: "Zelenograd", coordinate: MapDetails.startingLocation, aqData: AirQualityData(coord: Coord(lon: 50.0, lat: 50.0), list: [List(dt: 1606147200, main: Main(aqi: 4), components: ["co": 211.954, "so2": 0.648, "no2": 0.217, "o3": 72.456, "pm2_5": 2.563, "pm10": 5.757]), List(dt: 1606147200, main: Main(aqi: 4), components: ["so" : 0.648])]))

    func testLoadAnnotations() {
        let viewModel = MapViewModel()
        viewModel.loadAnnotationsByCurrentLocation()
        
        XCTAssertNotNil(viewModel.searchResults)
    }
    
    func testGetColorForAQI() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .index
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.red)
    }
    
    func testGetColorForSO2() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .SO2
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.green)
    }
    
    func testGetColorForNO2() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .NO2
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.green)
    }
    
    func testGetColorForO3() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .O3
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.yellow)
    }
    
    func testGetColorForCO() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .CO
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.green)
    }
    
    func testGetColorForPM2() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .PM2
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.green)
    }
    
    func testGetColorForPM10() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .PM10
        
        let color = mapView.getColorForSelectedParam(point)
        
        XCTAssertEqual(color, Color.green)
    }
    
    func testGetInfoForAQI() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .index
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "4")
    }
    
    func testGetInfoForSO2() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .SO2
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "0.6")
    }
    
    func testGetInfoForNO2() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .NO2
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "0.2")
    }
    
    func testGetInfoForPM10() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .PM10
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "5.8")
    }
    
    func testGetInfoForPM2() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .PM2
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "2.6")
    }
    
    func testGetInfoForO3() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .O3
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "72.5")
    }
    
    func testGetInfoForCO() {
        let viewModel = MapViewModel()
        let mapView = MapView(viewModel: viewModel)
        viewModel.selectedParam = .CO
        
        let str = mapView.getInfoForSelectedParam(point)
        
        XCTAssertEqual(str, "211")
    }
    
}
