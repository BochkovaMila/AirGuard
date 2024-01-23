//
//  CurrentDataViewModel.swift
//  AirGuard
//
//  Created by Mila B on 17.01.2024.
//

import SwiftUI
import CoreLocation

struct AddressLocation {
    var title: String
    var latitude: Double
    var longitude: Double
}

final class CurrentDataViewModel: ObservableObject {
    
    @ObservedObject var locationManager = LocationManager()
    
    var locationSearchViewModel = LocationSearchViewModel()
    
    @Published var addressString = ""
    
    init() {
        locationManager.lookUpLocation { address in
            self.addressString = address ?? "Москва"
            self.objectWillChange.send()
        }
    }
}
