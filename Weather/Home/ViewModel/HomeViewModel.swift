//
//  HomeViewModel.swift
//  Weather
//
//  Created by Kumar,Vishal on 26/05/21.
//

import Foundation

class HomeViewModel {

    var networkManager: NetworkManager = NetworkManager()
    var weatherData = [WeatherData]() {
        didSet {
            reloadDataCompletion?()
        }
    }

    var reloadDataCompletion: (() -> Void)?
    var reloadAndMoveCompletion: ((_ weatherData: WeatherData) -> Void)?
    func getWeatherData(cityId: Int) {
        networkManager.getWeatherReport(cityId: cityId) { (response, error) in
            DispatchQueue.main.async {
                if error == nil, let resp = response {
                    let weahterData = self.convertToStoreWeatherData(weatherResp: resp)
                    WeatherRepository.storeWeatherData(weatherData: weahterData)
                    self.weatherData.append(weahterData)
                } else {
                    AlertManager.showAlert(withTitle: "Error", message: error ?? "")
                }
            }
        }
    }

    func refreshWeatherData(cityId: Int) {
        networkManager.getWeatherReport(cityId: cityId) { (response, error) in
            DispatchQueue.main.async {
                if error == nil, let resp = response {
                    let weahterData = self.convertToStoreWeatherData(weatherResp: resp)
                    WeatherRepository.storeWeatherData(weatherData: weahterData)
                    self.getAllSavedWetherData()
                    self.reloadAndMoveCompletion?(weahterData)
                } else {
                    if let weather = self.weatherData.first(where: {$0.id == cityId}) {
                        self.reloadAndMoveCompletion?(weather)
                    }
                }
            }
        }
    }

    func checkWeatherDataStatus(cityId: Int) -> WeatherData? {
        return self.weatherData.filter({$0.id == cityId}).first
    }
    
    func getAllSavedWetherData() {
        if let weatherData = WeatherRepository.getAllWeatherData() {
            self.weatherData = weatherData
            reloadDataCompletion?()
        } else {
            self.weatherData = []
        }
    }

    func removeObject(cityId: Int) {
        WeatherRepository.removeWeatherData(cityId: cityId)
        getAllSavedWetherData()
    }

    private func convertToStoreWeatherData(weatherResp: WeatherResponse) -> WeatherData {
        let weatherData = WeatherData()
        weatherData.id =  weatherResp.id ?? -1
        weatherData.timezone = weatherResp.timezone ?? 0
        weatherData.name = weatherResp.name ?? ""
        weatherData.weatherId = weatherResp.weather?.first?.id ?? -1
        weatherData.weatherMain = weatherResp.weather?.first?.main ?? ""
        weatherData.weatherDesc = weatherResp.weather?.first?.description ?? ""
        weatherData.mainTemp = weatherResp.main?.temp ?? 00
        weatherData.mainFeelsLike = weatherResp.main?.feelsLike ?? 0
        weatherData.mainTempMin = weatherResp.main?.tempMin ?? 0
        weatherData.mainTempMax = weatherResp.main?.tempMax ?? 0
        weatherData.mainPressure = weatherResp.main?.pressure ?? 0
        weatherData.mainHumidity = weatherResp.main?.humidity ?? 0
        weatherData.mainSeaLevel = weatherResp.main?.seaLevel ?? 0
        weatherData.mainGroundLevel = weatherResp.main?.groundLevel ?? 0
        weatherData.visibility = weatherResp.visibility ?? 0
        weatherData.windSpeed = weatherResp.wind?.speed ?? 0
        weatherData.windDegree = weatherResp.wind?.deg ?? 0
        weatherData.windQust = weatherResp.wind?.gust ?? 0
        weatherData.date = weatherResp.dateCalculationTime ?? 0
        if let countryCode = weatherResp.sys?.country, let countryName = CountryCode.shared.countryDic[countryCode] {
            weatherData.countryName = countryName
        }
        return weatherData
    }
}
