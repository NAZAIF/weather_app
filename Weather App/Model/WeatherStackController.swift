//
//  WeatherStackController.swift
//  Weather App
//
//  Created by Moideen Nazaif VM on 10/07/20.
//  Copyright © 2020 Moideen Nazaif VM. All rights reserved.
//

import Foundation

private enum API {
    static let key = "<Weatherstack apikey here>"
}

final class WeatherStackController: WebServiceController {
    let fallbackService: WebServiceController?
    init(fallbackService: WebServiceController? = nil) {
        self.fallbackService = fallbackService
    }
    
    func fetchWeatherData(for city: String, completionHandler: @escaping (String?, WebServiceControllerError?) -> Void) {
        let endpoint = "http://api.weatherstack.com/current?access_key=\(API.key)&query=\(city)&units=f"
        
        // create a string that can be used in URLs
        let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        guard let endpointURL = URL(string: safeURLString) else {
            completionHandler(nil, WebServiceControllerError.invalidURL(safeURLString))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: endpointURL, completionHandler: { (data, response, error) -> Void in
            guard error == nil else {
                if let fallback = self.fallbackService {
                    fallback.fetchWeatherData(for: city, completionHandler: completionHandler)
                } else {
                    completionHandler(nil, WebServiceControllerError.forwarded(error!))
                }
                return
            }
            guard let responseData = data else {
                if let fallback = self.fallbackService {
                    fallback.fetchWeatherData(for: city, completionHandler: completionHandler)
                } else {
                    completionHandler(nil, WebServiceControllerError.invalidPayload(endpointURL))
                }
                return
            }
            
            // decode json
            let decoder = JSONDecoder()
            do {
                let weatherContainer = try decoder.decode(WeatherStackContainer.self, from: responseData)
                
                guard let weatherInfo = weatherContainer.current,
                    let weather = weatherInfo.weather_descriptions?.first,
                    let temperature = weatherInfo.temperature else {
                        completionHandler(nil, WebServiceControllerError.invalidPayload(endpointURL))
                        return
                }
                
                // compose weather information
                let weatherDescription = "\(weather) \(temperature) °F"
                print("Uses WeatherStack data")
                completionHandler(weatherDescription, nil)
            } catch let error {
                completionHandler(nil, WebServiceControllerError.forwarded(error))
            }
        })
        
        dataTask.resume()
    }
}
