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
    
    @Published var addressString = ""
    
    @Published var aqi = -1
    @Published var SO2 = -1.0
    @Published var NO2 = -1.0
    @Published var PM10 = -1.0
    @Published var PM2 = -1.0
    @Published var O3 = -1.0
    @Published var CO = -1.0
    
    init() {
        locationManager.lookUpLocation(lat: locationManager.region.center.latitude, long: locationManager.region.center.longitude) { address in
            self.addressString = address ?? "Москва"
            self.objectWillChange.send()
        }
        
        updateUI(with: locationManager.region.center.latitude, long: locationManager.region.center.longitude)
    }
    
    func updateUI(with lat: Double, long: Double) {
        self.fetchAQData(lat: lat, long: long) { aqData in
            self.aqi = aqData?.list.first?.main.aqi ?? -1
            self.SO2 = aqData?.list.first?.components["so2"] ?? -1.0
            self.NO2 = aqData?.list.first?.components["no2"] ?? -1.0
            self.PM10 = aqData?.list.first?.components["pm10"] ?? -1.0
            self.PM2 = aqData?.list.first?.components["pm2_5"] ?? -1.0
            self.O3 = aqData?.list.first?.components["o3"] ?? -1.0
            self.CO = aqData?.list.first?.components["co"] ?? -1.0
        }
    }
    
    private func fetchAQData(lat: Double, long: Double, completion: @escaping (AirQualityData?) -> Void) {
        
        Task {
            do {
                let aqData = try await NetworkManager.shared.getCurrentData(latitude: lat, longitude: long)
                completion(aqData)
            } catch {
                if let agError = error as? AGError {
                    let alert = UIAlertController(title: "Не удалось получить данные", message: "\(String(describing: agError.localizedDescription))", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
                    self.present(alert)
                } else {
                    let alert = UIAlertController(title: "Ошибка получения данных", message: "\(String(describing: error.localizedDescription))", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
                    self.present(alert)
                }
                completion(nil)
            }
        }
    }
}
