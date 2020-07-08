//
//  OpenWeatherMapController.swift
//  Weather App
//
//  Created by Moideen Nazaif VM on 08/07/20.
//  Copyright © 2020 Moideen Nazaif VM. All rights reserved.
//

import Foundation

private enum API {
    static let key = "<open weather api key here>"
}

class OpenWeatherMapController: WebServiceController {
    func fetchWeatherData(for city: String, completionHandler: @escaping (String?, WebServiceControllerError?) -> Void) {
        let endpoint = "https://api.openweathermap.org/data/2.5/find?q=\(city)&units=imperial&appid=\(API.key)"
        
        guard let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let endpointURL = URL(string: safeURLString) else {
            completionHandler(nil, .invalidURL(endpoint))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: endpointURL) { (data, response, error) in
            guard error == nil else {
                completionHandler(nil, .forwarded(error!))
                return
            }
            
            guard let responseData = data else {
                completionHandler(nil, .invalidPayload(endpointURL))
                return  
            }
        }
        
    }
    
    
}
