//
//  CityRepository.swift
//  Weather
//
//  Created by Kumar,Vishal on 28/05/21.
//

import Foundation
import RealmSwift
import SwiftSpinner

class CityRepository {
    
    static let backgroundQueue = DispatchQueue(label: "weather_realm_background", qos: .background)

    class func getAllCity() -> [City]? {
        if let url = Bundle.main.url(forResource: "cityList", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([City].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }

    class func saveAllCities() {
        let dataSaved = UserDefaultManger.shared.object(forKey: .cityDataSave) as? Bool ?? false
        if !dataSaved {
            SwiftSpinner.show("Fetching Cities")
            backgroundQueue.async {
                autoreleasepool {
                    if let cities = CityRepository.getAllCity() {
                        DispatchQueue.main.async {
                            SwiftSpinner.show("Storing Cities")
                        }
                        do {
                            let realm = try Realm()
                            try realm.write {
                                realm.add(cities, update: .modified)
                            }
                            UserDefaultManger.shared.set(true, forKey: .cityDataSave)
                            debugPrint(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
                            DispatchQueue.main.async {
                                SwiftSpinner.hide()
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }

    class func getAllCities() -> [City]? {
        do {
            let realm = try Realm()
            let cities = realm.objects(City.self)
            return Array(cities)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    class func getAllCities(searchText: String) -> [City]? {
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
            let cities = realm.objects(City.self).filter(predicate)
            return Array(cities)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
