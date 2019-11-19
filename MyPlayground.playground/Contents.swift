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
    let weather : [WeatherCond]?
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

struct WeatherErrorResponse: Codable {
    
    // {"cod":401, "message": "Invalid API key. Please see http://openweathermap.org/faq#error401 for more info."}
    
    // {"cod": 429,"message": "Your account is temporary blocked due to exceeding of requests limitation of your
    //  subscription type. Please choose the proper subscription http://openweathermap.org/price" }
    
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}

extension WeatherErrorResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}

class OpenWeatherClient
{
    static let apiKey = ""
    
    enum Endpoints {
        static let base = "https://api.openweathermap.org/data/2.5"
        
        case currentweather
        
        var stringValue : String {
            switch self {
            case .currentweather: return Endpoints.base + "/weather"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, queryItems: [URLQueryItem], responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {

        var finalURL:URL = url;

        var components = URLComponents(url: finalURL, resolvingAgainstBaseURL: false)!
        
        components.queryItems = queryItems
        
        if let urlWithQuery = components.url {
            
            finalURL = urlWithQuery
        }
        
        print(finalURL)
        
        let request = URLRequest(url: finalURL)
        // The default HTTP method for URLRequest is “GET”.
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            //print(data.map { String(format: "%02x", $0) }.joined())
            let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            print(string1)

            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(WeatherErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func getCurrentWeather(completion: @escaping (Bool, Error?, WeatherInformation?) -> Void) {
        
        let qItems = [URLQueryItem(name: "q", value: "London,uk"),
            URLQueryItem(name: "APPID", value: apiKey),
            URLQueryItem(name: "units", value: "imperial")]
        
        //+ "?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=" + restApiKey
        
        taskForGETRequest(url: Endpoints.currentweather.url, queryItems: qItems, responseType: WeatherInformation.self) { response, error in
            if let response = response {
                completion(true, nil, response)
            } else {
                print("false WeatherInformation")
                completion(false, error, nil)
            }
        }
    }
    
    class func handleCurrentWeatherResponse(success: Bool, error: Error?, response: WeatherInformation?) {
        if success {
            print("Happy WeatherInformation")
            
            if let thedata = response {
                print("\(thedata)")
            }
            
        } else {
            let message = error?.localizedDescription ?? ""
            print("\(message)");
            print("Sad WeatherInformation")
        }
    }
}

OpenWeatherClient.getCurrentWeather(completion: OpenWeatherClient.handleCurrentWeatherResponse)
