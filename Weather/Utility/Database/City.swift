//
//  City.swift
//  Weather
//
//  Created by Kumar,Vishal on 28/05/21.
//

import Foundation
import RealmSwift

@objcMembers
class City: Object, Decodable {
    dynamic var id: Int = -1
    dynamic var name: String = ""
    dynamic var state: String = ""
    dynamic var country: String = ""
    dynamic var coord: CityCoordinate?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case state
        case country
        case coord
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let id = try? container.decodeIfPresent(Int.self, forKey: .id) {
            self.id = id
        }
        if let name = try? container.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        }
        if let state = try? container.decodeIfPresent(String.self, forKey: .state) {
            self.state = state
        }
        if let country = try? container.decodeIfPresent(String.self, forKey: .country) {
            self.country = country
        }
        if let coord = try? container.decodeIfPresent(CityCoordinate.self, forKey: .coord) {
            self.coord = coord
        }
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }

    required override init() {
        super.init()
    }
    
}

@objcMembers
class CityCoordinate: Object, Decodable {

    dynamic var longitude: Double = 0
    dynamic var latitude: Double = 0

    private enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let longitude = try? container.decodeIfPresent(Double.self, forKey: .longitude) {
            self.longitude = longitude
        }
        if let latitude = try? container.decodeIfPresent(Double.self, forKey: .latitude) {
            self.latitude = latitude
        }
        super.init()
    }

    required override init() {
        super.init()
    }
}
