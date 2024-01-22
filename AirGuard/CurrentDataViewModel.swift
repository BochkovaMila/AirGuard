//
//  CurrentDataViewModel.swift
//  AirGuard
//
//  Created by Mila B on 17.01.2024.
//

import SwiftUI
import CoreLocation

final class CurrentDataViewModel: ObservableObject {
    
    @ObservedObject var locationManager = LocationManager()
    
    var locationSearchViewModel = LocationSearchViewModel()
    
    @Published var addressString = ""
    
    init() {
        locationManager.lookUpLocation { address in
            self.addressString = address ?? "Москва"
            self.objectWillChange.send()
            print("Address: \(self.addressString)")
        }
    }
}
