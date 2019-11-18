import UIKit
import Foundation

/*
 api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=f3d151ecf10d27b33ad637e6ab726aa1
 &units=imperial


 {
  "coord":{"lon":-0.13,"lat":51.51},
  "weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],
  "base":"stations",
  "main":{"temp":43.57,"pressure":1014,"humidity":93,"temp_min":42.01,"temp_max":45},
  "visibility":10000,
  "wind":{"speed":5.82,"deg":360},
  "clouds":{"all":75},
  "dt":1574042974,
  "sys":{"type":1,"id":1417,"country":"GB","sunrise":1574061787,"sunset":1574093303},
  "timezone":0,
  "id":2643743,
  "name":"London",
  "cod":200
 }
 
*/

struct WeatherInformation : Codable {
    let coord : WeatherCoord?
    let weather : WeatherCond?
    let base : String?
    let main : WeatherMain?
    let visibility : Int?
    let wind: WeatherWind?
    let clouds : WeatherClouds?
    let dt : Int?
    let sys : WeatherSys?
    let timezone : Int?
    let id : Int?
    let name : String?
    let cod : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case coord
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case dt
        case sys
        case timezone
        case id
        case name
        case cod
    }
}

struct WeatherCoord : Codable {
    let lat : Double?
    let lon : Double?
}

struct WeatherCond : Codable {
    let id : Int?
    let main : String?
    let description : String?
    let icon : String
}

struct WeatherMain : Codable {
    let temp : Double?
    let pressure : Int?
    let humidity : Int?
    let temp_min : Double?
    let temp_max : Double?
}

struct WeatherWind : Codable {
    let speed : Double?
    let deg : Int?
}

struct WeatherClouds : Codable {
    let all : Int?
}

struct WeatherSys : Codable {
    let type : Int?
    let id : Int?
    let country : String?
    let sunrise : Int?
    let sunset : Int?

}

