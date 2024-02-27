import Foundation
import CoreLocation

// A manager responsible for handling location-related tasks.
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    /// The system location manager instance.
    private let systemLocationManager = CLLocationManager()
    
    /// The current user location.
    private var currentLocation: CLLocation?
    
    /// The longitude and latitude coordinate.
    private var long = Double()
    private var lat = Double()
    
    /// A closure to be executed when the location is updated.
    private var delegate: (((Double, Double)) -> Void)?
    
    /// Set up the location manager.
    func setup() {
        systemLocationManager.delegate = self
        systemLocationManager.requestWhenInUseAuthorization()
        systemLocationManager.startUpdatingLocation()
    }
    
    /// Delegate method called when the location manager receives updated locations.
    /// - Parameters:
    ///   - manager: The location manager instance.
    ///   - locations: An array of location objects.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            currentLocation = locations.first
            long = currentLocation!.coordinate.longitude
            lat = currentLocation!.coordinate.latitude
            systemLocationManager.stopUpdatingLocation()
            
            self.delegate?((lat, long))
        }
    }
    
    /// Retrieves the current location.
    /// - Returns: The current location.
    func location() -> CLLocation? {
        return currentLocation
    }
    
    /// Retrieves the coordinates.
    /// - Returns: A tuple containing latitude and longitude.
    func coordinates() -> (Double, Double) {
        return (lat, long)
    }
    
    /// Adds a delegate closure to be called when the location is updated.
    /// - Parameter delegate: A closure taking latitude and longitude as parameters.
    func addDelegate(delegate: @escaping ((Double, Double)) -> Void) {
        self.delegate = delegate
    }
    
}
