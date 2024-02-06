import Foundation


class WeatherProvider {
    
    struct WeatherCurrent {
        var temperature: Float = 0
        var windSpeed: Float = 0
        var humidity: Float = 0
        var conditions: String = ""
        var timezone: String = ""
    }
    
    struct WeatherForecast {
        var datetime: String = ""
        var temperature: Float = 0
        var conditions: String = ""
    }
    
    private var weatherCurrent = WeatherCurrent()
    private var weatherForecast10Days: [WeatherForecast] = []
    
    private let keyURLString = "SEGQ9YES8T55WUMCE8CNRVCJR"
    
    private var delegateWeatherCurrent: ((WeatherCurrent) -> Void)?
    private var delegateWeatherForecast: (([WeatherForecast]) -> Void)?
    
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
                
                weatherCurrent = WeatherCurrent(temperature: details.currentConditions.temp,
                                      windSpeed: details.currentConditions.windspeed,
                                      humidity: details.currentConditions.humidity,
                                      conditions: details.currentConditions.conditions,
                                      timezone: details.timezone)
                for i in 0...9 {
                    weatherForecast10Days.append(WeatherForecast(datetime: details.days[i].datetime, temperature: details.days[i].temp, conditions: details.days[i].conditions))
                }
                print(weatherForecast10Days)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                self.delegateWeatherCurrent?(weatherCurrent)
                self.delegateWeatherForecast?(weatherForecast10Days)
            }
        }.resume()
    }
    
    func addDelegateWeatherCurrent(delegate: @escaping (WeatherCurrent) -> Void) {
        self.delegateWeatherCurrent = delegate
    }
    
    func addDelegateWeatherForecast(delegate: @escaping ([WeatherForecast]) -> Void) {
        self.delegateWeatherForecast = delegate
    }
    
}
