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
    
    
    func getAddressFromLatLon(Latitude: Double, Longitude: Double) -> String {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        var addressString : String = ""

        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = Latitude
        center.longitude = Longitude

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }


                    print(addressString)
              }
        })
        return addressString
    }
    
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
                    print("Search error: \(error.localizedDescription)")
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
                let aqData = try await NetworkManager.shared.getData(latitude: latitude, longitude: longitude)
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
