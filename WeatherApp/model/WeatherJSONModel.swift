import Foundation


struct WeatherDetails: Decodable {
    let timezone: String
    let currentConditions: WeatherCurrentCondition
    let address: String
    let days: [Day]
}


struct WeatherCurrentCondition: Decodable {
    let temp: Float
    let humidity: Float
    let windspeed: Float
    let conditions: String
    let datetime: String
}


struct Day: Decodable {
    let datetime: String
    let temp: Float
    let icon: String
}
