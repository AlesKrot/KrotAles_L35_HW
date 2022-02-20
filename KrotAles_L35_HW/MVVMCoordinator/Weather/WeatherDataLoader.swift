//
//  WeaterDataLoader.swift
//  Lesson23API
//
//  Created by Max Bystryk on 20.12.2021.
//

import Foundation

class WeatherDataLoader {
    enum WeatherDataParamsKey: String {
        case apiKey = "appid"
        case units
        case city = "q"
    }
    
    let baseURLString = "https://api.openweathermap.org"
    let weatherPath = "/data/2.5/weather/"
    let apiKey = "0014025dc57a54a20f44ba71397e18b0"
    let units = "metric"
    
    func loadWeatherData(forCity city: String, completionHandler: @escaping (WeatherData?, Error?) -> Void) {
        var components = URLComponents(string: baseURLString)
        components?.path = weatherPath
        let apiKeyItem = URLQueryItem(name: WeatherDataParamsKey.apiKey.rawValue, value: apiKey)
        let cityItem = URLQueryItem(name: WeatherDataParamsKey.city.rawValue, value: city)
        let unitsItem = URLQueryItem(name: WeatherDataParamsKey.units.rawValue, value: units)
        components?.queryItems = [cityItem, apiKeyItem, unitsItem]
        
        guard let url = components?.url else { return }
        
        let request = URLRequest(url: url)
        
//        let queryString = "?q=\(city)&appid=\(apiKey)&units=metric"
//        guard let url = URL(string: baseURLString + weatherPath + queryString) else { return }
//        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, responce, error in
            guard error == nil, let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            let weatherData = try? decoder.decode(WeatherData.self, from: data)
            
            DispatchQueue.main.async {
                completionHandler(weatherData, nil)
            }
        }
        
        dataTask.resume()
    }
}
