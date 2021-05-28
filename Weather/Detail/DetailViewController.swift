//
//  DetailViewController.swift
//  Weather
//
//  Created by Kumar,Vishal on 28/05/21.
//

import UIKit

class DetailViewController: UIViewController, StoryboardInstantiatable {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var firstOuterView: UIView!
    @IBOutlet weak var secondOuterView: UIView!
    @IBOutlet weak var firstContainerView: UIView!
    
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblMainTemp: UILabel!
    @IBOutlet weak var lblFeelsLikeTemp: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblTempDesc: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblWeekName: UILabel!
    
    var weatherData: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        setValue()
    }

    func setupNavigation() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    func setupView() {
        firstOuterView.layer.cornerRadius = self.firstOuterView.frame.height / 2
        secondOuterView.layer.cornerRadius = self.secondOuterView.frame.height / 2
        firstContainerView.layer.cornerRadius = self.secondOuterView.frame.height / 2
        firstOuterView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        secondOuterView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        firstContainerView.backgroundColor = .clear
    }
    
    func setValue() {
        guard let data = self.weatherData else {
            return
        }
        lblMainTemp.text = "\(data.mainTemp)°"
        lblFeelsLikeTemp.text = "\(data.mainFeelsLike)°"
        lblMinTemp.text = "\(data.mainTempMin)°"
        lblMaxTemp.text = "\(data.mainTempMax)°"
        lblTempDesc.text = data.weatherDesc.capitalized
        lblWindSpeed.text = "\(data.windSpeed)Km/h"
        lblWeekName.text = getTime()
        if data.weatherDesc.lowercased().contains("cloud") {
            imgWeather.image = UIImage(named: "rain")
        } else  {
            if CheckTime() {
                imgWeather.image = UIImage(named: "sunny")
            } else {
                imgWeather.image = UIImage(named: "moon")
            }
        }
    }
    
    func getTime() -> String {
        guard let data = self.weatherData else {
            return ""
        }
        let nowUTC = Date(timeIntervalSince1970: data.date)
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        if let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) {
            let dateFormatter = DateFormatter()
            return dateFormatter.string(from: localDate)
        }
        return ""
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
