//
//  WeatherData.swift
//  Lesson23API
//
//  Created by Max Bystryk on 20.12.2021.
//

import Foundation

struct WeatherData: Decodable {
    let mainWeatherData: MainWeatherData?
    
    enum CodingKeys: String, CodingKey {
        case mainWeatherData = "main"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.mainWeatherData = try? container.decode(MainWeatherData.self, forKey: .mainWeatherData)
    }
}

struct MainWeatherData: Decodable {
    let temperature: Double?
    let feelsLike: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.temperature = try? container.decode(Double.self, forKey: .temperature)
        self.feelsLike = try? container.decode(Double.self, forKey: .feelsLike)
    }
}
