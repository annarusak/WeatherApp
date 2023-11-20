import Foundation


class WeatherProvider {
    
    struct Weather {
        var temperature: Float = 0
        var windSpeed: Float = 0
        var humidity: Float = 0
        var conditions: String = ""
        var timezone: String = ""
    }
    
    private var currentWeather = Weather()
    private let keyURLString = "SEGQ9YES8T55WUMCE8CNRVCJR"
    private var delegate: ((Weather) -> Void)?
    
    func request(location : (latitude: Double, longitude: Double)) {
        
        let urlString = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/" + String(location.latitude) + "%2C" + String(location.longitude) + "?unitGroup=metric&key=" + keyURLString + "&contentType=json"
        
        // Doing URL request, check and parse our json, assign weather values we need to variables we made at the beginning
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [self] data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString!)

            do {
                let decoder = JSONDecoder()
                let details = try decoder.decode(WeatherDetails.self, from: data)
                
                currentWeather = Weather(temperature: details.currentConditions.temp,
                                      windSpeed: details.currentConditions.windspeed,
                                      humidity: details.currentConditions.humidity,
                                      conditions: details.currentConditions.conditions,
                                      timezone: details.timezone)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                self.delegate?(currentWeather)
            }
        }.resume()
    }
    
    func addDelegate(delegate: @escaping (Weather) -> Void) {
        self.delegate = delegate
    }
    
}
