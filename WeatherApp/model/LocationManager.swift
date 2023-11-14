import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

    
    private let systemLocationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var long = Double()
    private var lat = Double()
    private var delegate: (((Double, Double)) -> Void)?
    
    func setup() {
        systemLocationManager.delegate = self
        systemLocationManager.requestWhenInUseAuthorization()
        systemLocationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            currentLocation = locations.first
            long = currentLocation!.coordinate.longitude
            lat = currentLocation!.coordinate.latitude
            systemLocationManager.stopUpdatingLocation()
            
            self.delegate?((lat, long))
        }
    }
    
    func location() -> CLLocation? {
        return currentLocation
    }
    
    func coordinates() -> (Double, Double) {
        return (lat, long)
    }
    
    func addDelegate(delegate: @escaping ((Double, Double)) -> Void) {
        self.delegate = delegate
    }
}
