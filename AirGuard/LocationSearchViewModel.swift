//
//  LocationSearchViewModel.swift
//  AirGuard
//
//  Created by Mila B on 22.01.2024.
//

import Foundation
import MapKit
import SwiftUI

struct SearchAddressResult: Identifiable, Decodable {
    var id = UUID()
    let title: String
    let subtitle: String
}

class LocationSearchViewModel: NSObject, ObservableObject {
    
    @Published var results: Array<SearchAddressResult> = []
    @Published var searchableText = ""
    
    @ObservedObject var locationManager = LocationManager()

    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()
    
    func searchAddress(_ searchableText: String) {
        guard searchableText.isEmpty == false else { return }
        localSearchCompleter.queryFragment = searchableText
    }

}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            results = completer.results.map {
                SearchAddressResult(title: $0.title, subtitle: $0.subtitle)
            }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Ошибка получения местоположения", message: "\(String(describing: error.localizedDescription))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        self.present(alert)
    }
}
