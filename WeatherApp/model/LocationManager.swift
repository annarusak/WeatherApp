import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var long = Double()
    private var lat = Double()
    
    func setup() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            currentLocation = locations.first
            long = currentLocation!.coordinate.longitude
            lat = currentLocation!.coordinate.latitude
            print("\(long) | \(lat)")
        }
    }
    
    func location() -> CLLocation? {
        return currentLocation
    }
    
    func coordinates() -> (Double, Double) {
        return (long, lat)
    }
}
