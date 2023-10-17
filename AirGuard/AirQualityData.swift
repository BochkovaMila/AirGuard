//
//  AirQualityData.swift
//  AirGuard
//
//  Created by Mila B on 17.10.2023.
//

import Foundation

struct AirQualityData: Codable {
    let coord: Coord
    let list: [List]
}

struct Coord: Codable {
    let lon, lat: Double
}

struct List: Codable {
    let dt: Int
    let main: Main
    let components: [String: Double]
}

struct Main: Codable {
    let aqi: Int
}
