//
//  WeatherRepository.swift
//  Weather
//
//  Created by Kumar,Vishal on 28/05/21.
//

import Foundation
import RealmSwift

class WeatherRepository {

    class func storeWeatherData(weatherData: WeatherData) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(weatherData, update: .modified)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    class func getAllWeatherData() ->  [WeatherData]? {
        do {
            let realm = try Realm()
            let weatherDataResult = realm.objects(WeatherData.self)
            return Array(weatherDataResult)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    class func removeWeatherData(cityId: Int) {
        do {
            let realm = try Realm()
            if let weatherObj = realm.object(ofType: WeatherData.self, forPrimaryKey: cityId) {
                try realm.write{
                    realm.delete(weatherObj)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
