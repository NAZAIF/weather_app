//
//  WebServiceController.swift
//  Weather App
//
//  Created by Moideen Nazaif VM on 08/07/20.
//  Copyright © 2020 Moideen Nazaif VM. All rights reserved.
//

import Foundation

public enum WebServiceControllerError: Error {
    case invalidURL(String)
    case invalidPayload(URL)
    case forwarded(Error)
}

public protocol WebServiceController {
    init(fallbackService: WebServiceController?)
    
    var fallbackService: WebServiceController? { get }
    
    func fetchWeatherData(for city: String, completionHandler: @escaping (String?, WebServiceControllerError?) -> Void)
}
