//
//  WeatherData.swift
//  Weather
//
//  Created by Kumar,Vishal on 28/05/21.
//

import Foundation
import RealmSwift

@objcMembers
class WeatherData: Object {
    
    dynamic var id: Int = -1
    dynamic var timezone: TimeInterval = 0
    dynamic var name: String = ""
    dynamic var weatherId: Int = -1
    dynamic var weatherMain: String = ""
    dynamic var weatherDesc: String = ""
    dynamic var mainTemp: Double = 0
    dynamic var mainFeelsLike: Double = 0
    dynamic var mainTempMin: Double = 0
    dynamic var mainTempMax: Double = 0
    dynamic var mainPressure: Int = 0
    dynamic var mainHumidity: Int = 0
    dynamic var mainSeaLevel: Int = 0
    dynamic var mainGroundLevel: Int = 0
    dynamic var visibility: Int = 0
    dynamic var windSpeed: Double = 0
    dynamic var windDegree: Int = 0
    dynamic var windQust: Double = 0
    dynamic var countryName: String = ""
    dynamic var date: Double = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
