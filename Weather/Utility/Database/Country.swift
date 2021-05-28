//
//  Country.swift
//  Weather
//
//  Created by Kumar,Vishal on 28/05/21.
//

import Foundation

class Country: Decodable {
    var Code: String
    var Name: String
}


class CountryCode {
    static let shared = CountryCode()
    var countryDic = [String: String]()
    private init() {}

    func initalizeDic() {
        if let url = Bundle.main.url(forResource: "country", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let countries = try decoder.decode([Country].self, from: data)
                for country in countries {
                    countryDic[country.Code] = country.Name
                }
            } catch {
                print("error:\(error)")
            }
        }
    }
    
}
