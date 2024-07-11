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
            self.addressString = address ?? "Paris"
            self.objectWillChange.send()
        }
        
        getDataFromUserDefaults()
    }
    
    func updateUI(lat: Double, lon: Double) {
        self.fetchAQData(lat: lat, long: lon) { aqData in
            self.aqi = aqData?.list.first?.main.aqi ?? -1
            self.SO2 = aqData?.list.first?.components["so2"] ?? -1.0
            self.NO2 = aqData?.list.first?.components["no2"] ?? -1.0
            self.PM10 = aqData?.list.first?.components["pm10"] ?? -1.0
            self.PM2 = aqData?.list.first?.components["pm2_5"] ?? -1.0
            self.O3 = aqData?.list.first?.components["o3"] ?? -1.0
            self.CO = aqData?.list.first?.components["co"] ?? -1.0
            
            if lat == self.locationManager.region.center.latitude, lon == self.locationManager.region.center.longitude {
                UserDefaults.standard.set(self.aqi, forKey: "aqi")
                UserDefaults.standard.set(self.SO2, forKey: "so2")
                UserDefaults.standard.set(self.PM2, forKey: "pm2_5")
                UserDefaults.standard.set(self.PM10, forKey: "pm10")
                UserDefaults.standard.set(self.O3, forKey: "o3")
                UserDefaults.standard.set(self.NO2, forKey: "no2")
                UserDefaults.standard.set(self.CO, forKey: "co")
            }
        }
    }
    
    private func getDataFromUserDefaults() {
        if UserDefaults.standard.bool(forKey: "didStartTimerBefore") == false {
            UserDefaults.standard.set(true, forKey: "didStartTimerBefore")
            let now = Calendar.current.dateComponents(in: .current, from: Date())
            let anHourFromNow = DateComponents(year: now.year, month: now.month, day: now.day, hour: now.hour! + 1, minute: now.minute, second: now.second)
            let date = Calendar.current.date(from: anHourFromNow)
            UserDefaults.standard.set(date, forKey: "60MinuteTimer")
            
            updateUI(lat: locationManager.region.center.latitude, lon: locationManager.region.center.longitude)
        }
        if UserDefaults.standard.object(forKey: "60MinuteTimer") != nil {
            if Date() > UserDefaults.standard.object(forKey: "60MinuteTimer") as! Date {
                // more than 60 minutes has passed, update current data
                let now = Calendar.current.dateComponents(in: .current, from: Date())
                let anHourFromNow = DateComponents(year: now.year, month: now.month, day: now.day, hour: now.hour! + 1, minute: now.minute, second: now.second)
                let date = Calendar.current.date(from: anHourFromNow)
                UserDefaults.standard.set(date, forKey: "60MinuteTimer")
                
                updateUI(lat: locationManager.region.center.latitude, lon: locationManager.region.center.longitude)
            } else {
                // less than 60 minutes has passed
                self.aqi = UserDefaults.standard.integer(forKey: "aqi")
                self.SO2 = UserDefaults.standard.double(forKey: "so2")
                self.PM2 = UserDefaults.standard.double(forKey: "pm2_5")
                self.PM10 = UserDefaults.standard.double(forKey: "pm10")
                self.O3 = UserDefaults.standard.double(forKey: "o3")
                self.NO2 = UserDefaults.standard.double(forKey: "no2")
                self.CO = UserDefaults.standard.double(forKey: "co")
            }
        }
    }
    
    private func fetchAQData(lat: Double, long: Double, completion: @escaping (AirQualityData?) -> Void) {
        
        Task {
            do {
                let aqData = try await NetworkManager.shared.getCurrentData(latitude: lat, longitude: long)
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
