//
//  WeatherAPI.swift
//  Smart Weather
//
//  Created by Игорь Силаев on 12/04/2020.
//  Copyright © 2020 Игорь Силаев. All rights reserved.
//

import Foundation

struct WeatherAPI {
    
    let city: String?
    let country: String?
    let longitude: Double?
    let latitude: Double?
    let weatherID: Int?
    let mainWeather: String?
    let weatherDescription: String?
    let weatherIconID: String?
    
    private let temp: Double?
    
    var tempCelsius: Double {
        get {
            return (temp ?? 0) - 273.15
        }
    }
    
    var tempFahrenheit: Double {
        get {
            return ((temp ?? 0) - 273.15) * 1.8 + 32
        }
    }
    
    let humidity: Int?
    let pressure: Double?
    let cloudCover: Int?
    let windSpeed: Double?
    let windDirection: Double?
    let rainfallInLast3Hours: Double?
    
    init(weatherData: [String: AnyObject]) {
        
        city = weatherData["name"] as? String
        
        let coordDict = weatherData["coord"] as? [String: Double]
        longitude = coordDict?["lon"]
        latitude = coordDict?["lat"]
        
        let weatherDict = weatherData["weather"]?[0] as? [String: AnyObject]
        weatherID = weatherDict?["id"] as? Int
        mainWeather = weatherDict?["main"] as? String
        weatherDescription = weatherDict?["description"] as? String
        weatherIconID = weatherDict?["icon"] as? String
        
        let mainDict = weatherData["main"] as? [String: AnyObject]
        temp = mainDict?["temp"] as? Double
        humidity = mainDict?["humidity"] as? Int
        pressure = mainDict?["pressure"] as? Double
        
        cloudCover = weatherData["clouds"]?["all"] as? Int
        
        let windDict = weatherData["wind"] as? [String: Double]
        windSpeed = windDict?["speed"]
        windDirection = windDict?["deg"]
        
        if let rain = weatherData["rain"] {
            let rainDict = rain as? [String: Double]
            rainfallInLast3Hours = rainDict?["3h"]
        } else {
            rainfallInLast3Hours = nil
        }
        
        let sysDict = weatherData["sys"] as? [String: AnyObject]
        country = sysDict?["country"] as? String
        
    }
    
}
