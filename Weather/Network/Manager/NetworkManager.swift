//
//  NetworkManager.swift
//  Weather
//
//  Created by Kumar,Vishal on 26/05/21.
//

import Foundation

/// Network environment
enum NetworkEnvironment {
    case production
}

/// Network Response
enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case networkConnection = "Please check your network connection."
}

/// Result
enum Result<String>{
    case success
    case failure(String)
}

/// Network manager i.e manages all network related task
struct NetworkManager {

    /// Current environment
    static let environment: NetworkEnvironment = .production

    /// API KEY
    static let weatherApiKey = "577927ac166c8bbde02542b4aff393f1"

    /// Router
    let router = Router<WeatherAPI>()

    /// Getting current weather
    /// - Parameters:
    ///   - city: City
    ///   - completion: Returns weather response or any error response
    func getWeatherReport(cityId: Int, completion: @escaping (_ weatherResponse: WeatherResponse?, _ error: String?) -> Void) {
        router.request(.getWeather(cityId: cityId)) { (data, response, error) in
            if error != nil {
                completion(nil, NetworkResponse.networkConnection.rawValue)
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(WeatherResponse.self, from: responseData)
                        completion(apiResponse, nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }

    /// Handling response on the basis of  network status code
    /// - Parameter response: HTTPURLResponse
    /// - Returns: Result wether response is success or failure
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

