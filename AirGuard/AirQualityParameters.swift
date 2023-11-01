//
//  AirQualityParameters.swift
//  AirGuard
//
//  Created by Mila B on 01.11.2023.
//

import Foundation
import SwiftUI

enum AirQualityParameters: String, Equatable, CaseIterable {
    case index  = "Индекс"
    case SO2 = "SO2"
    case NO2  = "NO2"
    case PM10 = "PM10"
    case PM2 = "PM2.5"
    case O3 = "O3"
    case CO = "CO"

    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
