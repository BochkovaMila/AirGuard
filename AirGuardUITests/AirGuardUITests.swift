//
//  AirGuardUITests.swift
//  AirGuardUITests
//
//  Created by Mila B on 17.10.2023.
//

import XCTest

final class AirGuardUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testCurrentDataPage() throws {
        
        let changeButton = app.buttons["ChangeLocationButton"]
        XCTAssertTrue(changeButton.exists)
        
        let moreButton = app.buttons["MoreInfoButton"]
        XCTAssertTrue(moreButton.exists)
        
        let aqiView = app.otherElements["AQIProgressView"]
        XCTAssertTrue(aqiView.exists)
    }
    
    func testCurrentDataChangeLocation() throws {
        let scrollViewsQuery = app.scrollViews
        let changeLocationButton = scrollViewsQuery.otherElements.buttons["ChangeLocationButton"]
        XCTAssertTrue(changeLocationButton.exists)
        changeLocationButton.tap()
        
        let textField = app.textFields["Введите местоположение"]
        XCTAssertTrue(textField.exists)
        
        app.keys["M"].tap()
        app.keys["u"].tap()
        app.keys["m"].tap()
        app.keys["b"].tap()
        app.keys["a"].tap()
        app.keys["i"].tap()
        
        let mumbai = scrollViewsQuery.otherElements.containing(.button, identifier:"Mumbai Airport").element
        XCTAssertTrue(mumbai.exists)
        mumbai.tap()
        
        let alert = app.alerts["Изменить местоположение"]
        XCTAssertTrue(alert.waitForExistence(timeout: 3))
        alert.scrollViews.otherElements.buttons["ОК"].tap()
        
        let aqiView = app.otherElements["AQIProgressView"]
        XCTAssertTrue(aqiView.waitForExistence(timeout: 3))
    }
    
    func testCurrentDataGetMoreInfo() throws {
        let changeButton = app.buttons["ChangeLocationButton"]
        XCTAssertTrue(changeButton.exists)
        
        let moreButton = app.buttons["MoreInfoButton"]
        XCTAssertTrue(moreButton.exists)
        
        let aqiView = app.otherElements["AQIProgressView"]
        XCTAssertTrue(aqiView.exists)
        
        moreButton.tap()
        
        let labelText = app.staticTexts["Название"]
        XCTAssertTrue(labelText.exists)
    }
    
    func testMapView() throws {

        app.tabBars["Tab Bar"].buttons["Карта"].tap()
        
        let picker = app.pickers["PickerView"]
        XCTAssertTrue(picker.exists)
        
        let locationButton = app.buttons["LocationButton"]
        XCTAssertTrue(locationButton.exists)
        locationButton.tap()
        
        sleep(1)
        
        let infoPoint = app.otherElements["InfoPoint"].firstMatch
        XCTAssertTrue(infoPoint.exists)
        infoPoint.tap()
        
        let detailedInfoView = app.otherElements.textViews["DetailedInfoView"]
        XCTAssertTrue(detailedInfoView.waitForExistence(timeout: 3))
        
    }
    
    func testStatisticsView() {
        app.tabBars["Tab Bar"].buttons["История"].tap()
        
        let startDate = app.datePickers["StartIntervalPicker"]
        XCTAssertTrue(startDate.exists)
        startDate.tap()
        
        let collectionViewsQuery = startDate.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["1"]/*[[".buttons[\"Thursday, February 1\"].staticTexts[\"1\"]",".staticTexts[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        startDate.tap()
        
        let endDate = app.datePickers["EndIntervalPicker"]
        XCTAssertTrue(endDate.exists)
        endDate.tap()
        
        let collectionViewsQuery2 = endDate.collectionViews
        collectionViewsQuery2.staticTexts["14"].tap()
        startDate.tap()
        
        let moreInfoButton = app.buttons["StatisticsMoreInfoButton"]
        XCTAssertTrue(moreInfoButton.exists)
        
        let changeLocationButton = app.buttons["StatisticsChangeLocationButton"]
        XCTAssertTrue(changeLocationButton.exists)
        
        let indexChart = app.otherElements["StatisticsIndexChart"]
        XCTAssertTrue(indexChart.exists)
        
        let so2Chart = app.otherElements["StatisticsSO2Chart"]
        XCTAssertTrue(so2Chart.exists)
        
        let no2Chart = app.otherElements["StatisticsNO2Chart"]
        XCTAssertTrue(no2Chart.exists)
        
        let pm10Chart = app.otherElements["StatisticsPM10Chart"]
        XCTAssertTrue(pm10Chart.exists)
        
        let pm2Chart = app.otherElements["StatisticsPM2Chart"]
        XCTAssertTrue(pm2Chart.exists)
        
        let o3Chart = app.otherElements["StatisticsO3Chart"]
        XCTAssertTrue(o3Chart.exists)
        
        let coChart = app.otherElements["StatisticsCOChart"]
        XCTAssertTrue(coChart.exists)
    }
    
    func testForecastView() {
        app.tabBars["Tab Bar"].buttons["Прогноз"].tap()
        
        let moreInfoButton = app.buttons["ForecastMoreInfoButton"]
        XCTAssertTrue(moreInfoButton.exists)
        
        let changeLocationButton = app.buttons["ForecastChangeLocationButton"]
        XCTAssertTrue(changeLocationButton.exists)
        
        let indexChart = app.otherElements["ForecastIndexChart"]
        XCTAssertTrue(indexChart.exists)
        
        let so2Chart = app.otherElements["ForecastSO2Chart"]
        XCTAssertTrue(so2Chart.exists)
        
        let no2Chart = app.otherElements["ForecastNO2Chart"]
        XCTAssertTrue(no2Chart.exists)
        
        let pm10Chart = app.otherElements["ForecastPM10Chart"]
        XCTAssertTrue(pm10Chart.exists)
        
        let pm2Chart = app.otherElements["ForecastPM2Chart"]
        XCTAssertTrue(pm2Chart.exists)
        
        let o3Chart = app.otherElements["ForecastO3Chart"]
        XCTAssertTrue(o3Chart.exists)
        
        let coChart = app.otherElements["ForecastCOChart"]
        XCTAssertTrue(coChart.exists)
    }
    
    func testSettingsViewChangeLocation() {
        app.tabBars["Tab Bar"].buttons["Настройка"].tap()
        
        let changeLocationButton = app.buttons["SettingsChangeLocationButton"]
        XCTAssertTrue(changeLocationButton.exists)
        changeLocationButton.tap()
        
        let changeLocationView = app.otherElements["SettingsChangeLocationView"]
        XCTAssertTrue(changeLocationView.waitForExistence(timeout: 3))
    }
    
    func testSettingsViewMoreInfo() {
        app.tabBars["Tab Bar"].buttons["Настройка"].tap()
        
        let moreInfoButton = app.buttons["SettingsMoreInfoButton"]
        XCTAssertTrue(moreInfoButton.exists)
        moreInfoButton.tap()
        
        let moreInfoView = app.otherElements["SettingsMoreInfoView"]
        XCTAssertTrue(moreInfoView.waitForExistence(timeout: 3))
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
