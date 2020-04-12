//
//  Client.swift
//  Smart Weather
//
//  Created by Игорь Силаев on 12/04/2020.
//  Copyright © 2020 Игорь Силаев. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol WeatherDelegate {
    func didGetWeather(weather : WeatherAPI)
    func didNotGetWeather()
}

class Client: NSObject {
    
    var delegate: WeatherDelegate
    
    init(delegate : WeatherDelegate) {
        self.delegate = delegate
    }
    
    func getWeatherByCity(city: String) {
        guard let weatherRequestURL = URL(string: "\(openWeatherURL)?q=\(city)&appid=\(openWeatherIPkey)") else { return }
        getWeather(weatherRequestURL: weatherRequestURL)
        
    }

    private let openWeatherURL = "https://api.openweathermap.org/data/2.5/weather"
    private let openWeatherIPkey = "bd5ac2232bd727451b6e7146911a3ea5"
    
    func getWeather(weatherRequestURL : URL){
        let task = URLSession.shared.dataTask(with: weatherRequestURL) { (data, response, error) in
            if error != nil {
                self.delegate.didNotGetWeather()
            } else {
                if let usableData = data {
                    do {
                        let weatherJSONData = try JSONSerialization.jsonObject(with: usableData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                        let weather = WeatherAPI(weatherData: weatherJSONData)
                        if weatherJSONData["cod"] as? String == "404" { self.delegate.didNotGetWeather()
                        } else {
                            self.delegate.didGetWeather(weather: weather)
                        }
                    }  catch {
                        self.delegate.didNotGetWeather()
                    }
                }
            }
            
        }
        task.resume()
    }
}

