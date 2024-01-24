//
//  ForecastViewModel.swift
//  AirGuard
//
//  Created by Mila B on 24.01.2024.
//

import SwiftUI


final class ForecastViewModel: ObservableObject {
    
    @ObservedObject var locationManager = LocationManager()
    
    @Published var addressString = ""

    
    init() {
        locationManager.lookUpLocation(lat: locationManager.region.center.latitude, long: locationManager.region.center.longitude) { address in
            self.addressString = address ?? "Москва"
            self.objectWillChange.send()
        }
        
        updateUI(with: locationManager.region.center.latitude, long: locationManager.region.center.longitude)
    }
    
    func updateUI(with lat: Double, long: Double) {
        // fetch data & update UI
    }
}
