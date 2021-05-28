//
//  LocationTableViewCell.swift
//  Weather
//
//  Created by Kumar,Vishal on 27/05/21.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblWeatherStatus: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func setCell(weather: WeatherData) {
        debugPrint(weather)
        lblCountryName.text = weather.countryName
        lblCityName.text = weather.name
        lblWeatherStatus.text = weather.weatherDesc.capitalized
        lblTemp.text = "\(weather.mainTemp)°"
        if weather.weatherDesc.lowercased().contains("cloud") {
            imgWeather.image = UIImage(named: "rain")
        } else  {
            if CheckTime() {
                imgWeather.image = UIImage(named: "sunny")
            } else {
                imgWeather.image = UIImage(named: "moon")
            }
        }
    }
    
    func CheckTime() -> Bool{
        var timeExist: Bool
        let calendar = Calendar.current
        let startTimeComponent = DateComponents(calendar: calendar, hour:8)
        let endTimeComponent   = DateComponents(calendar: calendar, hour: 17, minute: 00)

        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startTime    = calendar.date(byAdding: startTimeComponent, to: startOfToday)!
        let endTime      = calendar.date(byAdding: endTimeComponent, to: startOfToday)!

        if startTime <= now && now <= endTime {
            imgWeather.image = UIImage()
//            print("between 8 AM and 5:30 PM")
            timeExist = true
        } else {
//            print("not between 8 AM and 5:30 PM")
            timeExist = false
        }
        return timeExist
    }
}
