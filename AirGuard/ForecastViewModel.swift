//
//  ForecastViewModel.swift
//  AirGuard
//
//  Created by Mila B on 24.01.2024.
//

import SwiftUI

struct AirQualityList: Codable, Identifiable {
    var id = UUID()
    let date: Date
    let main: Main
    let components: [String: Double]
}

final class ForecastViewModel: ObservableObject {
    
    @ObservedObject var locationManager = LocationManager()
    
    @Published var addressString = ""
    @Published var forecastData = [AirQualityList]()

    
    init() {
        locationManager.lookUpLocation(lat: locationManager.region.center.latitude, long: locationManager.region.center.longitude) { address in
            self.addressString = address ?? "Paris"
            self.objectWillChange.send()
        }
        
        updateUI(with: locationManager.region.center.latitude, long: locationManager.region.center.longitude)
    }
    
    func updateUI(with lat: Double, long: Double) {
        self.fetchForecast(lat: lat, long: long) { forecast in
            var forecastList = [AirQualityList]()
            for item in forecast?.list ?? [] {
                let forecastItem = AirQualityList(
                    date: Date(timeIntervalSince1970: TimeInterval(item.dt)),
                    main: item.main,
                    components: item.components
                )
                forecastList.append(forecastItem)
            }
            self.forecastData = forecastList
        }
    }
    
    private func fetchForecast(lat: Double, long: Double, completion: @escaping (AirQualityData?) -> Void) {
        
        Task {
            do {
                let aqData = try await NetworkManager.shared.getForecastData(latitude: lat, longitude: long)
                completion(aqData)
            } catch {
                if let agError = error as? AGError {
                    let alert = UIAlertController(title: "Failed to load data", message: "\(String(describing: agError.localizedDescription))", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel))
                    self.present(alert)
                } else {
                    let alert = UIAlertController(title: "Failed to get data", message: "\(String(describing: error.localizedDescription))", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel))
                    self.present(alert)
                }
                completion(nil)
            }
        }
    }
}
