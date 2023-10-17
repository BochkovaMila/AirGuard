//
//  ContentViewModel.swift
//  AirGuard
//
//  Created by Mila B on 17.10.2023.
//

import SwiftUI

final class ContentViewModel: ObservableObject {
    
    @ObservedObject var locationManager = LocationManager()
    @Published var airQualityData = ""
    
    func fetchAQData() {
        let latitude = locationManager.region.center.latitude
        let longitude = locationManager.region.center.longitude
        
        Task {
            do {
                let aqData = try await NetworkManager.shared.getData(latitude: latitude, longitude: longitude)
                print(aqData)
                DispatchQueue.main.async { [self] in
                    self.airQualityData = "\(aqData.list[0].main.aqi)"
                }
            } catch {
                if let agError = error as? AGError {
                    print(agError)
                } else {
                    print(error)
                }
            }
        }
    }
}
