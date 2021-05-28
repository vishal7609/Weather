//
//  WeatherEndPoint.swift
//  Weather
//
//  Created by Kumar,Vishal on 26/05/21.
//

import Foundation

/// Weather API
enum WeatherAPI {
    case getWeather(cityId: Int)
}

extension WeatherAPI: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://api.openweathermap.org/data/2.5/weather"
        }
    }

    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getWeather:
            return ""
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .getWeather(cityId: let cityId):
            var parameter = [String: Any]()
            parameter["id"] = cityId
            parameter["appid"] = NetworkManager.weatherApiKey
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: parameter)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
}
