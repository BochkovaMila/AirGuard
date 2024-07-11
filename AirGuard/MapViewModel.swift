//
//  ContentViewModel.swift
//  AirGuard
//
//  Created by Mila B on 17.10.2023.
//

import SwiftUI
import MapKit

struct InfoPoint: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    var aqData: AirQualityData?
}

final class MapViewModel: ObservableObject {
    
    @ObservedObject var locationManager = LocationManager()
    @Published var airQualityData = ""
    @Published var searchResults: [InfoPoint] = []
    @Published var address: String?
    @Published var selectedParam: AirQualityParameters = .index
    
    func loadAnnotationsByCurrentLocation() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "places of interest"
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(
            center: locationManager.region.center,
            span: locationManager.region.span
        )
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let mapItems = response?.mapItems else {
                if let error = error {
                    let alert = UIAlertController(title: "Failed to find the location", message: "\(String(describing: error.localizedDescription))", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel))
                    self.present(alert)
                }
                return
            }
            
            self.convertMapItemsToInfoPoints(mapItems: mapItems) { infoPoints in
                DispatchQueue.main.async {
                    self.searchResults = infoPoints
                }
            }
        }
    }
    
    private func convertMapItemsToInfoPoints(mapItems: [MKMapItem], completion: @escaping ([InfoPoint]) -> Void) {
        var result: [InfoPoint] = []
        let group = DispatchGroup()
        
        for mapItem in mapItems {
            group.enter()
            convertMapItemToInfoPoint(mapItem: mapItem) { infoPoint in
                result.append(infoPoint)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(result)
        }
    }
    
    private func convertMapItemToInfoPoint(mapItem: MKMapItem, completion: @escaping (InfoPoint) -> Void) {
        fetchAQData(region: mapItem.placemark.coordinate) { aqData in
            let infoPoint = InfoPoint(name: mapItem.name ?? "Unknown location", coordinate: mapItem.placemark.coordinate, aqData: aqData)
            completion(infoPoint)
        }
    }
    
    private func fetchAQData(region: CLLocationCoordinate2D, completion: @escaping (AirQualityData?) -> Void) {
        let latitude = region.latitude
        let longitude = region.longitude
        
        Task {
            do {
                let aqData = try await NetworkManager.shared.getCurrentData(latitude: latitude, longitude: longitude)
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
