//
//  WeatherResponse.swift
//  Weather
//
//  Created by Kumar,Vishal on 26/05/21.
//

import Foundation

struct WeatherResponse: Decodable {
    var coordinate: Coordinate?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var rain: Rain?
    var clouds: Clouds?
    var dateCalculationTime: TimeInterval?
    var sys: System?
    var timezone: TimeInterval?
    var id: Int?
    var name: String?
    var cod: Int?
    
    private enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weather
        case base
        case main
        case visibility
        case wind
        case rain
        case clouds
        case dateCalculationTime = "dt"
        case sys
        case timezone
        case id
        case name
        case cod
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let coordinate = try? container.decodeIfPresent(Coordinate.self, forKey: .coordinate) {
            self.coordinate = coordinate
        }
        if let weather = try? container.decodeIfPresent([Weather].self, forKey: .weather) {
            self.weather = weather
        }
        if let base = try? container.decodeIfPresent(String.self, forKey: .base) {
            self.base = base
        }
        if let main = try? container.decodeIfPresent(Main.self, forKey: .main) {
            self.main = main
        }
        if let visibility = try? container.decodeIfPresent(Int.self, forKey: .visibility) {
            self.visibility = visibility
        }
        if let wind = try? container.decodeIfPresent(Wind.self, forKey: .wind) {
            self.wind = wind
        }
        if let rain = try? container.decodeIfPresent(Rain.self, forKey: .rain) {
            self.rain = rain
        }
        if let clouds = try? container.decodeIfPresent(Clouds.self, forKey: .clouds) {
            self.clouds = clouds
        }
        if let dateCalculationTime = try? container.decodeIfPresent(TimeInterval.self, forKey: .dateCalculationTime) {
            self.dateCalculationTime = dateCalculationTime
        }
        if let sys = try? container.decodeIfPresent(System.self, forKey: .sys) {
            self.sys = sys
        }
        if let timezone = try? container.decodeIfPresent(TimeInterval.self, forKey: .timezone) {
            self.timezone = timezone
        }
        if let id = try? container.decodeIfPresent(Int.self, forKey: .id) {
            self.id = id
        }
        if let name = try? container.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        }
        if let cod = try? container.decodeIfPresent(Int.self, forKey: .cod) {
            self.cod = cod
        }
    }
}


struct Coordinate: Decodable {

    var longitude: Double
    var latitude: Double

    private enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
    
}

struct Weather: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Main: Decodable {
    var temp: Double?
    var feelsLike: Double?
    var tempMin: Double?
    var tempMax: Double?
    var pressure: Int?
    var humidity: Int?
    var seaLevel: Int?
    var groundLevel: Int?

    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
    }
}


struct Wind: Decodable {
    var speed: Double
    var deg: Int
    var gust: Double
}

struct Rain: Decodable {
    var volumeLastOneHour: Double

    private enum CodingKeys: String, CodingKey {
        case volumeLastOneHour = "1h"
    }
}

struct Clouds: Decodable {
    var all: Int
}

struct System: Decodable {
    var type: Int
    var id: Int
    var country: String
    var sunrise: TimeInterval
    var sunset: TimeInterval
}
