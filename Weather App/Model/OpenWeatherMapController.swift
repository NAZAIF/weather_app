//
//  OpenWeatherMapController.swift
//  Weather App
//
//  Created by Moideen Nazaif VM on 08/07/20.
//  Copyright © 2020 Moideen Nazaif VM. All rights reserved.
//

import Foundation

private enum API {
    static let key = "<OpenWeatherMap apiKey here>"
}

final class OpenWeatherMapController: WebServiceController {
    let fallbackService: WebServiceController?
    
    init(fallbackService: WebServiceController? = nil) {
        self.fallbackService = fallbackService
    }
    
    func fetchWeatherData(for city: String, completionHandler: @escaping (String?, WebServiceControllerError?) -> Void) {
        let endpoint = "https://api.openweathermap.org/data/2.5/find?q=\(city)&units=imperial&appid=\(API.key)"
        
        guard let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let endpointURL = URL(string: safeURLString) else {
            completionHandler(nil, .invalidURL(endpoint))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: endpointURL) { (data, response, error) in
            guard error == nil else {
                if let fallback = self.fallbackService {
                    fallback.fetchWeatherData(for: city, completionHandler: completionHandler)
                } else {
                    completionHandler(nil, .forwarded(error!))
                }
                return
            }
            
            guard let responseData = data else {
                if let fallback = self.fallbackService {
                    fallback.fetchWeatherData(for: city, completionHandler: completionHandler)
                } else {
                    completionHandler(nil, .invalidPayload(endpointURL))
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let weatherList = try decoder.decode(OpenWeatherMapContainer.self, from: responseData)
                guard let weatherInfo = weatherList.list?.first, let weather = weatherInfo.weather.first?.main,
                    let temperature = weatherInfo.main.temp else {
                        completionHandler(nil, .invalidPayload(endpointURL))
                        return
                }
                
                let weatherDescription = "\(weather) \(temperature) ºF"
                print("Uses OpenWeatherMap data")
                completionHandler(weatherDescription, nil)
            } catch let error {
                completionHandler(nil, .forwarded(error))
            }
        }
        
        dataTask.resume()
    }
}
