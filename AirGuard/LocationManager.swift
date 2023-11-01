//
//  LocationManager.swift
//  AirGuard
//
//  Created by Mila B on 17.10.2023.
//

import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 55.9872, longitude: 37.2022)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)
}

final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var region = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span: MapDetails.defaultSpan
    )
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.setup()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    private func present(_ alert: UIAlertController, animated: Bool = true, completion: (() -> Void)? = nil) {
        // UIApplication.shared.keyWindow has been deprecated in iOS 13,
        // so you need a little workaround to avoid the compiler warning
        // https://stackoverflow.com/a/58031897/10967642
        
        let keyWindow = UIApplication
                            .shared
                            .connectedScenes
                            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                            .last
        keyWindow?.rootViewController?.present(alert, animated: animated, completion: completion)
    }
    
    private func setup() {
        switch locationManager.authorizationStatus {
            //If we are authorized then we request location just once,
            // to center the map
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            //If we don´t, we request authorization
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Possibly due to active restrictions such as parental controls being in place
            let alert = UIAlertController(title: "Location Permission Restricted", message: "The app cannot access your location. This is possibly due to active restrictions such as parental controls being in place. Please disable or remove them and enable location permissions in settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                // Redirect to Settings app
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert)
        
        case .denied:
            let alert = UIAlertController(title: "Location Permission Denied", message: "Please enable location permissions in settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                // Redirect to Settings app
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert)
            
        default:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: - handle errors
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        }
    }
    
    
}
