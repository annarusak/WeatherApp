import Foundation

// A class responsible for providing weather information.
class WeatherProvider {
    
    // Structure representing current weather conditions.
    struct WeatherCurrent {
        var temperature: Float = 0
        var windSpeed: Float = 0
        var humidity: Float = 0
        var conditions: String = ""
        var timezone: String = ""
    }
    
    // Structure representing weather forecast for a day.
    struct WeatherForecast {
        var datetime: String = ""
        var temperature: Float = 0
        var icon: String = ""
    }
    
    /// The current weather conditions.
    private var weatherCurrent = WeatherCurrent()
    
    /// The weather forecast for the next 10 days.
    private var weatherForecast10Days: [WeatherForecast] = []
    
    /// The API key for accessing weather data.
    private let keyURLString = "SEGQ9YES8T55WUMCE8CNRVCJR"
    
    /// A closure to handle current weather data updates.
    private var delegateWeatherCurrent: ((WeatherCurrent) -> Void)?
    
    /// A closure to handle weather forecast data updates.
    private var delegateWeatherForecast: (([WeatherForecast]) -> Void)?
    
    /// Requests weather information for a given location.
    /// - Parameter location: A tuple containing latitude and longitude.
    func request(location : (latitude: Double, longitude: Double)) {
        
        let urlString = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/" + String(location.latitude) + "%2C" + String(location.longitude) + "?unitGroup=metric&key=" + keyURLString + "&contentType=json"
        
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
                /// Decode the JSON response into WeatherDetails structure
                let decoder = JSONDecoder()
                let details = try decoder.decode(WeatherDetails.self, from: data)
                
                /// Update the weatherCurrent structure with current weather details
                weatherCurrent = WeatherCurrent(temperature: details.currentConditions.temp,
                                                windSpeed: details.currentConditions.windspeed,
                                                humidity: details.currentConditions.humidity,
                                                conditions: details.currentConditions.conditions,
                                                timezone: details.timezone)
                /// Parse the weather forecast for the next 10 days
                for i in 1...10 {
                    weatherForecast10Days.append(WeatherForecast(datetime: details.days[i].datetime,
                                                                 temperature: details.days[i].temp,
                                                                 icon: details.days[i].icon))
                }
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                /// Call the delegate closure to pass the current weather data and weather forecast data
                self.delegateWeatherCurrent?(weatherCurrent)
                self.delegateWeatherForecast?(weatherForecast10Days)
            }
        }.resume()
    }
    
    /// Adds a delegate closure to handle current weather updates.
    /// - Parameter delegate: A closure taking a `WeatherCurrent` object as a parameter.
    func addDelegateWeatherCurrent(delegate: @escaping (WeatherCurrent) -> Void) {
        self.delegateWeatherCurrent = delegate
    }
    
    /// Adds a delegate closure to handle weather forecast updates.
    /// - Parameter delegate: A closure taking an array of `WeatherForecast` objects as a parameter.
    func addDelegateWeatherForecast(delegate: @escaping ([WeatherForecast]) -> Void) {
        self.delegateWeatherForecast = delegate
    }
    
}
