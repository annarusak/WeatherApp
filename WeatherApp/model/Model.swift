import Foundation


struct WeatherDetails: Decodable {
    let timezone: String
    let currentConditions: WeatherCurrentCondition
    let address: String
}


struct WeatherCurrentCondition: Decodable {
        let temp: Float
        let humidity: Float
        let windspeed: Float
        let conditions: String
        let datetime: String
    
//        let stations: [String]
}
