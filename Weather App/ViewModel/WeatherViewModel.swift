//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Moideen Nazaif VM on 08/07/20.
//  Copyright © 2020 Moideen Nazaif VM. All rights reserved.
//

import Foundation

class WeatherViewModel: ObservableObject {
    private let weatherService = OpenWeatherMapController(fallbackService: WeatherStackController())
    
    //    @Published allows SwiftUI to observe this property and update view whenever this property changes.
    @Published var weatherInfo = ""
    
    func fetch(city: String) {
        weatherService.fetchWeatherData(for: city) { (info, error) in
            guard error == nil, let weatherInfo = info else {
                DispatchQueue.main.async {
                    self.weatherInfo = "Could not retrieve weather information for \(city)"
                }
                return
            }
            DispatchQueue.main.async {
                self.weatherInfo = weatherInfo
            }
        }
    }
}
