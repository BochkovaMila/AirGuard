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
            let alert = UIAlertController(title: "Разрешение на определение местоположения ограничено", message: "Приложение не может получить доступ к вашему местоположению. Возможно, это связано с активными ограничениями, такими как родительский контроль. Пожалуйста, отключите или удалите их и включите разрешения на определение местоположения в настройках.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
                // Redirect to Settings app
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
            present(alert)
        
        case .denied:
            let alert = UIAlertController(title: "Разрешение на определение местоположения запрещено", message: "Пожалуйста, включите разрешения на определение местоположения в настройках.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
                // Redirect to Settings app
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
            present(alert)
            
        default:
            break
        }
    }
    
    func getCoordinate(from address: String, completion: @escaping ((Double, Double)?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error != nil {
                let alert = UIAlertController(title: "Не удалось получить местоположение", message: "\(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
                self.present(alert)
                completion(nil)
                return
            }
            
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                DispatchQueue.main.async {
                    self.region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    )
                }
                completion((coordinate.latitude, coordinate.longitude))
            }
            else
            {
                let alert = UIAlertController(title: "Подходящее местоположение не найдено", message: "\(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
                self.present(alert)
            }
        }
    }
    
    func lookUpLocation(lat: Double, long: Double, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        let currentLocation = CLLocation(latitude: lat, longitude: long)
        
        geocoder.reverseGeocodeLocation(currentLocation, preferredLocale: Locale(components: Locale.Components(languageCode: "ru"))) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.locality else {
                completion(nil)
                return
            }
            print("Location: \(location)")
            completion(location)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Ошибка определения местоположения", message: "\(String(describing: error.localizedDescription))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        self.present(alert)
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

extension CLPlacemark {

    var address: String? {
        if let name = name {
            var result = name

            if let street = thoroughfare {
                result += ", \(street)"
            }

            if let city = locality {
                result += ", \(city)"
            }

            if let country = country {
                result += ", \(country)"
            }

            return result
        }

        return nil
    }

}
