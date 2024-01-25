//
//  ForecastViewModel.swift
//  AirGuard
//
//  Created by Mila B on 24.01.2024.
//

import SwiftUI

struct ForecastList: Codable, Identifiable {
    var id = UUID()
    let date: Date
    let main: Main
    let components: [String: Double]
}

final class ForecastViewModel: ObservableObject {
    
    @ObservedObject var locationManager = LocationManager()
    
    @Published var addressString = ""
    @Published var forecastData = [ForecastList]()

    
    init() {
        locationManager.lookUpLocation(lat: locationManager.region.center.latitude, long: locationManager.region.center.longitude) { address in
            self.addressString = address ?? "Москва"
            self.objectWillChange.send()
        }
        
        updateUI(with: locationManager.region.center.latitude, long: locationManager.region.center.longitude)
    }
    
    func updateUI(with lat: Double, long: Double) -> [ForecastList] {
        var forecastList = [ForecastList]()
        self.fetchForecast(lat: lat, long: long) { forecast in
            
            for item in forecast?.list ?? [] {
                let forecastItem = ForecastList(
                    date: Date(timeIntervalSince1970: TimeInterval(item.dt)),
                    main: item.main,
                    components: item.components
                )
                forecastList.append(forecastItem)
            }
        }
        DispatchQueue.main.async {
            self.forecastData = forecastList
        }
        return forecastList
    }
    
    private func fetchForecast(lat: Double, long: Double, completion: @escaping (AirQualityData?) -> Void) {
        
        Task {
            do {
                let aqData = try await NetworkManager.shared.getForecastData(latitude: lat, longitude: long)
                completion(aqData)
            } catch {
                if let agError = error as? AGError {
                    print(agError)
                } else {
                    print(error)
                }
                completion(nil)
            }
        }
    }
    
    func getDataForDaysChart() -> [ForecastList] {
        let forecast = updateUI(with: locationManager.region.center.latitude, long: locationManager.region.center.longitude)
        
        print(forecast)
        
        var data = [ForecastList]()
        
//        data.append(forecast[23])
//        data.append(forecast[47])
//        data.append(forecast[71])
//        data.append(forecast[95])
        
        return data
    }
}
