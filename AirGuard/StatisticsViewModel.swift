//
//  StatisticsViewModel.swift
//  AirGuard
//
//  Created by Mila B on 30.01.2024.
//

import SwiftUI

final class StatisticsViewModel: ObservableObject {
    
    @ObservedObject var locationManager = LocationManager()
    
    @Published var addressString = ""
    @Published var historyData = [AirQualityList]()
    @Published var startDate = Date()
    @Published var endDate = Date()

    
    init() {
        locationManager.lookUpLocation(lat: locationManager.region.center.latitude, long: locationManager.region.center.longitude) { address in
            self.addressString = address ?? "Москва"
            self.objectWillChange.send()
        }
        
        updateUI(lat: locationManager.region.center.latitude, lon: locationManager.region.center.longitude)
    }
    
    func updateUI(lat: Double, lon: Double) {
        
        if endDate < startDate {
            let temp = startDate
            startDate = endDate
            endDate = temp
        }
        
        self.fetchHistory(lat: lat, lon: lon, start: Int(startDate.timeIntervalSince1970), end: Int(endDate.timeIntervalSince1970)) { history in
            var historyList = [AirQualityList]()
            for item in history?.list ?? [] {
                let historyItem = AirQualityList(
                    date: Date(timeIntervalSince1970: TimeInterval(item.dt)),
                    main: item.main,
                    components: item.components
                )
                historyList.append(historyItem)
            }
            self.historyData = historyList
        }
    }
    
    private func fetchHistory(lat: Double, lon: Double, start: Int, end: Int, completion: @escaping (AirQualityData?) -> Void) {
        
        Task {
            do {
                let aqData = try await NetworkManager.shared.getHistoricalData(lat: lat, lon: lon, start: start, end: end)
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
}
